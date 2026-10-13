# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Tweetable is a Twitter-like Rails 7.0 app (Ruby 3.1.2, PostgreSQL) with Devise auth, GitHub OAuth, Active Storage avatars, and Hotwire via importmaps (no Node/bundler step). Views are server-rendered ERB styled entirely with Tailwind CSS 3 (via the `tailwindcss-rails` gem, no Node). There is no hand-written CSS outside `application.tailwind.css`.

`PRODUCT.md` (audience: recruiters/reviewers evaluating a portfolio piece) and `DESIGN.md` (design tokens and rules) describe the product and visual direction; `.impeccable/` and `.claude/skills/impeccable` are the design tooling that produced them.

## Commands

```bash
bundle install
bundle exec rails db:create db:migrate db:seed   # seeds wipe users/tweets/likes and recreate demo data
bundle exec rails server
bin/dev                      # server + Tailwind watcher (foreman, Procfile.dev)
bundle exec rails tailwindcss:build   # one-off CSS build
bundle exec rubocop          # lint (config in .rubocop.yml)
bundle exec rubocop -a       # autocorrect
```

The `bin/*` scripts other than `bin/dev` are not executable (no `+x`), so call them through `bundle exec` / `ruby bin/...`.

There is no test suite (no `test/` or `spec/` directory).

Local setup notes:
- `.ruby-version` pins Ruby 3.1.2 (rbenv). A shell without rbenv initialized falls back to system Ruby 2.6, where `bin/dev` fails trying to install foreman; run `eval "$(rbenv init - zsh)"` first (or prefix commands with `RBENV_VERSION=3.1.2`).
- On recent Apple clang, the old native extensions (`nokogiri` 1.13.4, `nio4r` 2.5.8) fail to compile. Pass relaxed flags via env during `bundle install`, quoting the value (bundler splits on spaces):
  `BUNDLE_BUILD__NOKOGIRI="--with-cflags='-O3 -Wno-default-const-init-field-unsafe -Wno-error=incompatible-function-pointer-types'"` (same for `BUNDLE_BUILD__NIO4R`).
- `rails_live_reload` is in the development group, so views/assets reload the browser automatically.

Environment: copy `.env.example` to `.env` and set `GITHUB_KEY` / `GITHUB_SECRET` (loaded by `dotenv-rails`) for GitHub sign-in. `MAILER_SENDER` sets the From address for both Devise and `ApplicationMailer` (defaults to `Tweetable <no-reply@localhost>`).

Seeds (`db/seeds.rb`) create five users (`admin@mail.com`, `dog@mail.com`, `neil@mail.com`, `fist@mail.com`, `tanus@mail.com`), all with password `123456`; `admin@mail.com` is the only admin. Tweets and replies are random `Faker::Lorem` sentences, which is why `faker` is in the main Gemfile group.

## Architecture

**Data model** (`app/models/`):
- `Tweet` is self-referential: a reply is a `Tweet` with `replied_to_id` set (indexed, but no DB foreign key). `replies_count` and `likes_count` are counter caches maintained by `belongs_to ... counter_cache` on `Tweet#replied_to` and `Like#tweet`. Body is required, max 140 chars. Replies and likes are `dependent: :destroy`, so deleting a tweet deletes its whole reply tree.
- `Like` joins `User` and `Tweet`, unique per user/tweet pair (model validation plus a unique DB index).
- `User` uses Devise (incl. `:omniauthable`), an enum `role` (`member`/`admin`), `has_many :liked_tweets, through: :likes`, and a `has_one_attached :avatar`. A `before_create` hook attaches `app/assets/images/default_avatar.png` when no avatar is given.

**Auth**:
- `ApplicationController` requires sign-in for every action except `index` and `show`, and permits the extra Devise params `username`, `name`, `avatar`.
- Authorization lives in `Tweet#editable_by?` / `#deletable_by?`: only the author edits a tweet; the author or an `admin` can delete it. `TweetsController` enforces them in `before_action`s (redirect to the tweet with an alert otherwise) and `_tweet.html.erb` uses them to show the pencil/trash controls. That's the whole admin role: no panel, no other privileges. `role` isn't a permitted param anywhere, so it can only be changed from the console/seeds.
- Sign-in is throttled by `rack-attack` (`config/initializers/rack_attack.rb`): `POST /users/sign_in` per IP (5/20s) and per email (5/min, 20/h). Counters use an in-process `MemoryStore` (dev `Rails.cache` is a null store), so with several Puma workers each counts separately. A throttled request is redirected (303) back to the sign-in page with a flash alert, set and committed from the middleware.
- GitHub OAuth goes through `CallbacksController#github` → `User.from_omniauth` (configured in `config/initializers/devise.rb` and `devise_for` in `config/routes.rb`).
- Devise views are customized under `app/views/devise/` (the "Forgot your password?" link is commented out in `devise/shared/_links`).

**Request flow quirks**:
- Replies are created through `TweetsController#create` with `tweet[replied_to_id]` (set from params, not through `tweet_params`, which only permits `body`). After creating a reply the user is redirected to the parent tweet's show page; top-level tweets redirect to the index. Both set a `notice`.
- Likes are not addressed by `Like` id. `POST /likes?tweet=<tweet_id>` creates one (a duplicate hitting the unique index is rescued and ignored). `DELETE /likes/:id` takes the **tweet** id and destroys the current user's like on that tweet. Both respond with Turbo Streams (`LikesController#like_streams`): replace every `[data-like-button=ID]` copy of `likes/_button`, update the user's `likes_count`, and re-render `users/_liked_tweets`. HTML requests fall back to `redirect_back`. Whether a button renders as liked comes from `ApplicationController#liked_tweet_ids` (a helper method): the current user's liked tweet ids, plucked once per request and memoized, so a page costs one likes query regardless of how many buttons it has.
- Deleting a tweet does not use `turbo_confirm` (Turbo 7.1's confirm hook is synchronous). The trash button in `_tweet.html.erb` opens the shared `<dialog>` (`shared/_confirm_dialog`, Stimulus `confirm-dialog`, set on `<body>`, rendered only when signed in), which submits `DELETE /tweets/:id`. `TweetsController#destroy` answers with a Turbo Stream: removes every `[data-tweet=ID]` copy of the tweet and its replies (faded out by the `turbo:before-stream-render` listener in `application.js`), updates the author's tweet count, the author's and current user's like counts, the parent's `[data-replies-count]`, and appends a toast. On a tweet's own show page (`redirect_on_delete: true`) the form sends `redirect=1` and the action redirects instead.
- The same tweet can appear twice on a page (profile Tweets + Likes tabs), so Turbo Stream targets use data attributes (`data-tweet`, `data-like-button`, `data-replies-count`) with `remove_all`/`replace_all`/`update_all` instead of ids. `_tweet` takes an optional `scope` local to keep its DOM id unique.
- Timestamps show `time_ago_in_words` with the full date in the `<time title>`.
- Auth copy is mixed: the header uses "Log in" / "Log out" / "Sign up" / "Create an account", while the Devise pages and `devise.en.yml` say "Sign in".
- Routes are trimmed to what exists: `resources :likes, only: %i[create destroy]` (the only likes view is `likes/_button`) and `resources :users, only: [:show]`. `resources :tweets` is the full set; every action is used. Root is `tweets#index`, which paginates top-level tweets with `?page=N` (`TweetsController::PER_PAGE` = 20, offset-based, fetching one extra row to know if there is an older page; Newer/Older links under the list). Profile and thread pages are not paginated.

**Layout**: `app/views/layouts/application.html.erb` renders the sticky `header/_header` partial, a `max-w-2xl` `<main>`, a fixed `#toasts` container, the confirm dialog, and the footer. Pages set `content_for :title` (rendered as "X · Tweetable"). Flash `notice`/`alert` (including Devise's) render as `shared/_toast` (Stimulus `toast`: animates in, auto-dismisses after 4s, pauses on hover, removed before Turbo caches the page); Turbo Stream responses can `append` to `#toasts` too. Validation errors stay inline (`alert-box`). Empty states are a hidden `<p>` with `only:block`, so they appear once the last item is removed in place.

**JavaScript**: Stimulus controllers in `app/javascript/controllers/` are loaded automatically by `pin_all_from` in `config/importmap.rb`: `navbar` (mobile menu), `composer` (140-char countdown, disables submit while blank, used by `tweets/_form`), `confirm-dialog`, and `toast`. Add new JS the same way, and pin third-party deps with `bin/importmap pin <pkg>`. `ApplicationHelper#current_page_aria` sets `aria-current="page"` on header links (the nav styles key off it).

**Icons/images**: icons are inline SVG partials in `app/views/shared/icons/` (`render "shared/icons/heart", css: "size-5"`, default `size-5`); the only images are `logo_app.png` and `default_avatar.png` (seed avatars live in `db/images/`).

**Styling**: Tailwind input is `app/assets/stylesheets/application.tailwind.css`, config is `config/tailwind.config.js` (scans `public/*.html`, `app/views`, `app/helpers`, `app/javascript`; plugins forms/typography/container-queries), and output goes to the git-ignored `app/assets/builds/tailwind.css`, which the layout loads alongside `inter-font` and a Google Fonts link for Montserrat and Roboto. Classes only appear after a build, so run `bin/dev` or `tailwindcss:build`. The palette lives in the theme: `primary` 100-600 (rose), `gray` 100-500, `secondary` 100-600 and `error` 100-500; fonts are `sans` (Inter), `display` (Montserrat, applied to `h1`-`h3` in the base layer) and `logo` (Roboto, header wordmark). Reusable components are `@layer components` classes: `btn` (+ `btn-primary|secondary|danger|ghost`, `btn-sm`), `input`, `label`, `card`, `link`, `alert-box`, `action` (tweet-card icon controls, 36px tap target via padding cancelled by negative margin), `nav-row` (mobile menu rows); everything else is plain utilities in the views. Profile tabs are CSS-only, using named peers (`peer/tweets`, `peer/likes`). `assets/config/manifest.js` links `builds`, not `stylesheets`, so the raw `application.tailwind.css` is never served. The lockfile includes the `arm64-darwin` platform, which the gem needs for its binary; add `x86_64-linux` before deploying to Linux.

## Conventions

RuboCop (with `rubocop-rails`) enforces double-quoted strings, max line length 100 (comment lines exempt), method length 20, and AbcSize 30. `db/`, `bin/`, and `script/` are excluded from linting.

Note: `.gitignore` on `main` lists `CLAUDE.md`, so this file isn't tracked there.
