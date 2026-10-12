# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

The primary audience is evaluators: recruiters, hiring managers and code reviewers who look at Tweetable as a portfolio piece. They usually arrive cold, sign in with a seeded demo account (password `123456`; `admin@mail.com` is an admin) or with GitHub, and spend a few minutes trying the core loop. In that time they judge the product feel and the craft behind it. Their job is to quickly decide whether the author builds polished, coherent, working Rails and front-end software.

People who post, reply and like are the users the product simulates. Evaluators act as those people during a demo.

## Product Purpose

Tweetable is a short-form social app. People post tweets of up to 140 characters, reply in threads, like posts and keep a profile with an avatar. It exists to show end-to-end product craft in a server-rendered Rails app. Success means an evaluator finishes a demo session thinking it feels like a real, considered product rather than a tutorial clone.

## Positioning

It has the same mechanics as Twitter/X (short posts, replies, likes, profiles) but its own identity. Future work should not copy Twitter's look, terminology flourishes or layout by default. Familiar patterns are used where they serve usability, not to imitate.

## Operating Context

- Demo-driven usage. Seed data (`db/seeds.rb`) creates five personas with Faker tweets, replies and likes, and reseeding wipes all data. First impressions are therefore usually formed against seeded content, not organic content.
- Core loop: home feed → compose a tweet → open a tweet's thread → reply → like/unlike → view a profile (Tweets / Likes tabs) → delete your own tweet via a confirm dialog.
- Auth: email/password (Devise) or GitHub OAuth. Index and show pages are public, and everything else requires sign-in.

## Capabilities and Constraints

- Stack is fixed: Rails 7.0, Ruby 3.1.2, PostgreSQL, Hotwire (Turbo + Stimulus) via importmaps, Tailwind CSS 3 via `tailwindcss-rails`. There is no Node build step, and new JS is Stimulus controllers or importmap pins.
- Tweet bodies are capped at 140 characters (a validation rule, not stated as a core brand commitment).
- Roles: `member` and `admin`. **Admin moderation is planned**: the admin role is meant to gain moderation tools such as removing other users' tweets. It is not built yet.
- The UI is English-only. There are no i18n or localization plans.
- No test suite exists.

## Brand Commitments

- Name: "Tweetable". The existing logo is `app/assets/images/logo_app.png`.
- No voice or personality guidelines have been confirmed yet.

## Evidence on Hand

- Seeded demo personas and avatars: `db/seeds.rb`, `db/images/`.
- Default avatar: `app/assets/images/default_avatar.png`.
- There are no real users, usage metrics, testimonials or deployment URL. Future work must not invent any of these.

## Product Principles

1. **The first five minutes are the product.** An evaluator's demo session through the core loop is the critical path, so every step of it should feel finished.
2. **Its own product, not a costume.** Borrow mechanics from Twitter, not its identity.
3. **Craft shows in the details.** States, feedback, empty states and edge cases are where a portfolio piece shows quality, so leave none of them as raw scaffolding.
4. **Server-rendered first.** Solve things with Rails, Turbo and Stimulus before adding client-side machinery, to keep the stack story clean.
