---
name: Tweetable
description: Short notes on soft white cards, written in one warm rose ink.
colors:
  rose-ink: "#d44a78"
  rose-ink-deep: "#b23861"
  rose-bright: "#e76a94"
  rose-glow: "#f490b1"
  rose-blush: "#fabbd0"
  rose-wash: "#feebf1"
  graphite: "#424242"
  graphite-deep: "#292929"
  night-ink: "#17171c"
  body-ink: "#303036"
  muted-gray: "#7a7a7a"
  hairline: "#d3d3d3"
  paper: "#f2f2f2"
  card-white: "#ffffff"
  coral-signal: "#ea6c83"
  alarm-red: "#e02447"
  alarm-red-deep: "#c51c3b"
  alarm-wine: "#a11730"
typography:
  display:
    fontFamily: "Montserrat, Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.5rem"
    fontWeight: 600
    lineHeight: "2rem"
  headline:
    fontFamily: "Montserrat, Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.25rem"
    fontWeight: 600
    lineHeight: "1.75rem"
  title:
    fontFamily: "Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1rem"
    fontWeight: 600
    lineHeight: "1.5rem"
  body:
    fontFamily: "Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: "1.5rem"
  body-sm:
    fontFamily: "Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
    lineHeight: "1.25rem"
  button:
    fontFamily: "Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 600
    lineHeight: "1.25rem"
  label:
    fontFamily: "Inter var, ui-sans-serif, system-ui, sans-serif"
    fontSize: "0.75rem"
    fontWeight: 500
    lineHeight: "1rem"
    letterSpacing: "0.1em"
  wordmark:
    fontFamily: "Roboto, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.25rem"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.025em"
rounded:
  lg: "8px"
  xl: "12px"
  2xl: "16px"
  full: "9999px"
spacing:
  xs: "4px"
  sm: "12px"
  md: "16px"
  lg: "24px"
  xl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.rose-ink}"
    textColor: "{colors.card-white}"
    typography: "{typography.button}"
    rounded: "{rounded.full}"
    padding: "10px 20px"
  button-primary-hover:
    backgroundColor: "{colors.rose-ink-deep}"
  button-secondary:
    backgroundColor: "{colors.graphite}"
    textColor: "{colors.card-white}"
    typography: "{typography.button}"
    rounded: "{rounded.full}"
    padding: "10px 20px"
  button-secondary-hover:
    backgroundColor: "{colors.graphite-deep}"
  button-danger:
    backgroundColor: "{colors.alarm-red}"
    textColor: "{colors.card-white}"
    typography: "{typography.button}"
    rounded: "{rounded.full}"
    padding: "10px 20px"
  button-danger-hover:
    backgroundColor: "{colors.alarm-red-deep}"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.body-ink}"
    typography: "{typography.button}"
    rounded: "{rounded.full}"
    padding: "10px 20px"
  button-ghost-hover:
    backgroundColor: "{colors.paper}"
  button-sm:
    padding: "6px 16px"
  input:
    backgroundColor: "{colors.card-white}"
    textColor: "{colors.body-ink}"
    typography: "{typography.body}"
    rounded: "{rounded.lg}"
    padding: "8px 12px"
  card:
    backgroundColor: "{colors.card-white}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.md}"
  dialog:
    backgroundColor: "{colors.card-white}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.lg}"
    width: "384px"
  toast:
    backgroundColor: "{colors.night-ink}"
    textColor: "{colors.card-white}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.xl}"
    padding: "12px 16px"
    width: "384px"
  profile-tab:
    textColor: "{colors.muted-gray}"
    typography: "{typography.body}"
    padding: "12px 16px"
  profile-tab-active:
    textColor: "{colors.rose-ink-deep}"
---

# Design System: Tweetable

## Overview

**Creative North Star: "The Rose-Ink Postcard"**

Every tweet is a postcard: a short note on a soft white card, sitting on a quiet paper-gray table. The system is friendly, soft and tidy. Shapes are rounded, surfaces float slightly, and one warm rose ink marks everything you can write, send, like or follow. The rose works because it is the only warm color on screen. Everything else is a neutral run from Paper to Night Ink.

Density is calm. The whole app lives in a single 672px reading column, and cards stack with 12px gaps. Each card has generous 16px insets, so even a feed of 140-character posts reads like a stack of separate notes rather than a scrolling log. Craft shows at the edges: the 1px press on buttons, hairline rings on cards, toasts that slide in and pause under the pointer, and deleted tweets that fade and shrink away instead of vanishing.

The identity is Tweetable's own. It borrows Twitter's mechanics (short posts, replies, likes, profiles) but not its blue, its layout or its iconography. The signature is the typographic `{Tweet}able` wordmark: Roboto in curly braces, with "Tweet" written in rose.

**Key Characteristics:**
- One warm accent (Rose Ink) on an otherwise neutral, slightly cool palette.
- White cards with a 16px radius on a Paper canvas, lifted by a hairline ring and the faintest shadow.
- Pill-shaped buttons and avatars everywhere; nothing interactive has a sharp corner.
- Montserrat headings over Inter body text: geometric warmth on top, neutral readability underneath.
- A single centered 672px column on every screen size.
- Soft, short motion (150–300ms) used only for feedback, never decoration.

## Colors

A rose-pink accent ramp over a five-step neutral gray, with graphite for secondary actions and a red family kept strictly for destructive and error states. Each token maps to a Tailwind theme key, noted in parentheses.

### Primary
- **Rose Ink** (`primary-500`): The writing color. Primary buttons (Tweet, Sign in, Edit profile), text links and @usernames, the filled heart on liked tweets, and the hover tint on reply and like icons. If it is clickable and positive, it is Rose Ink.
- **Rose Ink Deep** (`primary-600`): The pressed version of Rose Ink. Hover state for primary buttons and links, and the active profile tab's text and 2px underline.
- **Rose Bright** (`primary-400`): Display-only. The "Tweet" half of the wordmark and the right end of the profile banner gradient. Never used for text smaller than the wordmark.
- **Rose Glow** (`primary-300`): Focus color. Button focus outlines, input focus borders and rings, tab focus rings. It also colors the success icon inside Night Ink toasts, where it reads well (8:1).
- **Rose Blush** (`primary-200`): The left end of the profile banner gradient, and hover fill for the avatar file-picker button.
- **Rose Wash** (`primary-100`): The faintest tint. Resting fill of the avatar file-picker button, with Rose Ink Deep text.

### Secondary
- **Graphite** (`secondary-500`): Secondary buttons: Log out, and "Continue with GitHub" on the auth cards. It is neutral but solid, so it carries an action without competing with Rose Ink.
- **Graphite Deep** (`secondary-600`): Hover state for Graphite buttons.

### Tertiary
- **Alarm Red** (`error-300`): The danger button (Delete in the confirm dialog) and the hover tint on the trash icon.
- **Alarm Red Deep** (`error-400`): Danger button hover, and the trash glyph inside the dialog's icon chip.
- **Alarm Wine** (`error-500`): Text inside inline validation boxes (`alert-box`).
- **Coral Signal** (`error-100`): The alert icon in error toasts. At 20% opacity it is also the fill of validation boxes and of the dialog's icon chip.

### Neutral
- **Night Ink** (`gray-500`): Headings, author names and the toast surface. At 50% opacity it is the dialog backdrop.
- **Body Ink** (`gray-400`): Default body text, set on `<body>`. Tweet text, wordmark letters and ghost button text.
- **Muted Gray** (`gray-300`): Secondary text: timestamps, reply and like counts, form labels, inactive tabs, the header tagline and the footer.
- **Hairline** (`gray-200`): Borders, dividers, card rings (at 70%), input strokes, placeholder text, and the "OR" rules on auth cards.
- **Paper** (`gray-100`): The page canvas, ghost button hover fill, and the faint tweet-card hover (at 40%).
- **Card White** (`#ffffff`): Every surface that holds content: cards, inputs, the dialog, the mobile menu, and the header (at 80% over a blur).

### Named Rules

**The One Warm Color Rule.** Rose Ink and its ramp are the only warm hues in the product. Don't introduce a second accent (no blue links, no green success). Success is already Rose Glow on Night Ink.

**The Red Means Gone Rule.** The error ramp appears only for destructive actions (delete) and failures (validation, alert toasts). Never use it for emphasis, badges or decoration.

**The Contrast Debt Rule.** Three incumbent pairings fall below WCAG AA for small text: white on Rose Ink (4.16:1, used on 14px button labels), Muted Gray on Card White (4.29:1), and Muted Gray on Paper (3.83:1, used in the footer). Don't extend these pairings to new places. When a new label must be rose with white text, put it on Rose Ink Deep (5.78:1).

## Typography

**Display Font:** Montserrat (falls back to Inter var, then system sans), loaded from Google Fonts at weights 600 and 700.
**Body Font:** Inter var (falls back to system sans), from the `inter-font` gem.
**Wordmark Font:** Roboto (500/700), used only for the `{Tweet}able` logotype.

**Character:** Montserrat's wide geometric caps give headings a friendly, postcard-header warmth. Inter keeps the 140-character bodies plain and highly legible. The base layer applies Montserrat to every `h1`–`h3` automatically.

### Hierarchy
- **Display** (Montserrat 600, 1.5rem / 2rem): Page titles ("Home", "Tweet Detail") and the auth card headings ("Sign in to your account"). One per screen.
- **Headline** (Montserrat 600, 1.25rem / 1.75rem): The profile name under the avatar. The dialog title ("Delete tweet?") uses a step down at 1.125rem.
- **Title** (Inter 600, 1rem / 1.5rem): Author names on tweet cards, in Night Ink.
- **Body** (Inter 400, 1rem / 1.5rem): Tweet text, in Body Ink with `whitespace-pre-line` and `break-words`. The 672px column caps lines at roughly 75 characters.
- **Body Small** (Inter 400, 0.875rem / 1.25rem): Meta lines (@username, "3 hours ago"), counts, nav links, toast messages, dialog copy and the footer.
- **Button** (Inter 600, 0.875rem): All button labels. Small buttons drop to 0.75rem.
- **Label** (Inter 500, 0.75rem, 0.1em tracking, uppercase): Form field labels, the "Replies" section heading and the "OR" divider. Always Muted Gray.

### Named Rules

**The Quiet Uppercase Rule.** Uppercase is reserved for 12px tracked labels in Muted Gray. Headings and buttons stay in sentence case.

**The Braces Belong to the Logo Rule.** Curly braces and Roboto appear only in the wordmark. Don't reuse them as a decorative motif or as a heading font.

## Layout

There is one layout model: a centered single column, `max-w-2xl` (672px), with a 16px side gutter. Header, main and footer all share that width, so edges line up from top to bottom. `<main>` has 32px of vertical padding and grows to push the footer to the bottom of short pages.

- **Rhythm:** 12px between stacked cards (`space-y-3`), 24px between page sections (page title to composer, composer to feed, profile card to tabs), and 16px inside cards. Auth cards widen their inset to 32px and cap at 448px (`max-w-md`), centered. Dialogs use 24px.
- **Tweet card anatomy:** a 44px avatar and name/meta stack in a row with a 12px gap, the body 12px below, and the action row (reply, like, then edit and delete pushed right) 16px below that, with 24px between actions.
- **Composer:** the same card shape. The avatar sits beside a borderless 96px textarea, and a hairline-topped footer right-aligns the small Tweet button.
- **Responsive:** the only breakpoint is `md` (768px). Below it, the header nav collapses into a menu-button panel (white, full-width, `shadow-md`, over a dimmed backdrop). Above it, the nav sits inline. The column itself never changes, so content is identical at every width.
- **Overlays:** toasts stack bottom-center, 24px from the edge, at most 384px wide. The confirm dialog is centered, at most 384px wide, and keeps 16px clear of the edges on phones.

## Elevation & Depth

The system uses soft lift. Content surfaces float just above the Paper canvas, with a 1px hairline ring at 70% Hairline doing most of the edge work and `shadow-sm` adding the faintest grounding. Larger shadows are reserved for things that sit above the page: the mobile menu, toasts and the dialog. The sticky header is not a shadowed surface. It separates from content with translucency (white at 80%, `backdrop-blur`) and a Hairline bottom border.

### Shadow Vocabulary
- **Resting lift** (`box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05)` plus a `0 0 0 1px rgb(211 211 211 / 0.7)` ring): Cards and solid buttons. Ghost buttons drop it.
- **Menu** (`box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`): The mobile nav dropdown under the header.
- **Toast** (`box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)`): Floating notifications.
- **Dialog** (`box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)`): The modal, over a Night Ink 50% backdrop with a small blur.

### Named Rules

**The Postcard Rests Rule.** Cards are on the table, not hovering over it. A card never gets more than the resting lift. Hover feedback on a tweet card is a faint Paper tint, not a bigger shadow.

**The Overlay Earns Its Shadow Rule.** Only surfaces that cover other content (menu, toast, dialog) step up the shadow scale, and each step up means "further above the page".

## Shapes

The form language is pillowy. Anything you press is a full pill (9999px): buttons, the file-picker button, the mobile menu button and avatar crops. Containers get gently curved 16px corners: cards, the confirm dialog and the profile card, which clips its 96px rose gradient banner. Smaller nested elements step down to 12px for toasts and 8px for inputs and validation boxes, so a radius never exceeds the radius of its parent.

Avatars are always circles with `object-cover`: 44px in cards and the composer, 96px on the profile with a 4px white ring as it overlaps the banner. Icon chips (the trash in the dialog) are 40px circles. Edges are drawn with 1px Hairline lines or rings, never thick borders. The one exception is the 2px underline on the active profile tab.

## Components

### Buttons
Soft and tactile: rounded pills that press down a pixel when clicked.
- **Shape:** Full pill (9999px), 10px × 20px padding, 8px icon gap, Inter 600 at 0.875rem, resting lift shadow.
- **Primary:** Rose Ink with white text. For the main forward action on a surface (Tweet, Reply, Sign in, Sign up, Edit profile, Log in).
- **Secondary:** Graphite with white text. For neutral actions that still need weight (Log out, Continue with GitHub).
- **Danger:** Alarm Red with white text. Only inside the delete confirmation.
- **Ghost:** Transparent with Body Ink text and no shadow, filling with Paper on hover. For dismissive actions (Cancel).
- **Small:** 6px × 16px padding and 0.75rem text. Used for header actions, the composer submit and dialog buttons.
- **Hover / Focus / Active:** Hover deepens the fill one ramp step (150ms). Keyboard focus draws a 2px Rose Glow outline offset by 2px. Active nudges the button down 1px (`translate-y-px`). Full-width variants (`w-full`) appear on auth cards.

### Cards / Containers
- **Corner Style:** Gently curved (16px).
- **Background:** Card White on Paper.
- **Shadow Strategy:** Resting lift only (see Elevation). Tweet cards add a 40% Paper tint on hover.
- **Border:** A 70% Hairline ring instead of a border.
- **Internal Padding:** 16px for tweets and the composer, 24px for the dialog, 32px for auth cards.

### Inputs / Fields
- **Style:** Card White fill, 1px Hairline stroke, 8px radius, full width, Body Ink text, Hairline placeholder (via `@tailwindcss/forms`).
- **Focus:** The stroke and a 1px ring both shift to Rose Glow.
- **Labels:** The uppercase Label style, 4px above the field.
- **File inputs:** The picker button becomes a Rose Wash pill with Rose Ink Deep text, darkening to Rose Blush on hover.
- **Error:** Errors don't tint the field. They appear in an inline validation box above the form: Coral Signal at 20% fill, Alarm Wine text, 8px radius, a semibold count heading and a bulleted list.
- **Composer exception:** The tweet textarea has no border, ring or background, so it reads as writing directly on the card.

### Navigation
- **Header:** Sticky, 56px, translucent white with a blur and a Hairline bottom border. The `{Tweet}able` wordmark sits at left. At right are Body Ink "Home" and "Profile" pill links (the current page turns Rose Ink Deep via `aria-current`) and a small button (Graphite "Log out" when signed in; a "Sign up" link and Rose Ink "Log in" when signed out). No tagline.
- **Mobile:** Below 768px, a 40px round menu button (menu ↔ close icon, `aria-expanded`, "Open/Close menu") drops a full-width white panel (fade + 8px slide, 200ms) over a 30% Night Ink backdrop and locks page scroll. Signed in, the panel shows the user (avatar, name, @handle), then 48px icon rows (`nav-row`: Home, Profile, Edit profile; the current one on Rose Wash with Rose Ink Deep text) and a full-width Graphite "Log out". Signed out, it shows "Log in" and "Create an account". It closes from the toggle, a backdrop tap, Escape (focus returns to the button), before Turbo caches the page, and on growing to desktop (Stimulus `navbar`).
- **Profile tabs:** CSS-only radio tabs. Inactive tabs are Muted Gray, darkening to Night Ink on hover. The active tab is semibold Rose Ink Deep with a 2px Rose Ink Deep underline. Focus draws a 2px Rose Glow ring.

### Tweet Card (signature)
The core unit of the product. A card with a 44px circular avatar, the author name (Title style) beside the @username (a Rose Ink link), and a relative timestamp below that links to the thread. Then the body (Body style), then an action row in Muted Gray: reply (icon and count), like (outline heart, or a filled Rose Ink heart when liked), and, for the owner only, edit and delete pushed to the right. Action icons tint Rose Ink on hover, except trash, which tints Alarm Red. Icons are 20px inline SVG partials from `shared/icons/`.

### Toast (signature)
A Night Ink pill-rectangle (12px radius), bottom-center, with a 24px icon (Rose Glow check for notices, Coral Signal exclamation for alerts), Body Small text and a dismiss X in Hairline that brightens to white. It slides up 8px and fades in over 300ms, auto-dismisses after 4s, pauses while hovered, and leaves the way it came in.

### Confirm Dialog
A native `<dialog>`, 384px wide, 16px radius, with the dialog shadow over a blurred 50% Night Ink backdrop. A 40px Coral-tinted circle holds the Alarm Red Deep trash icon beside a headline and a single line of Muted Gray consequence copy. Buttons are right-aligned: a ghost Cancel (autofocused) and a Danger Delete. Clicking the backdrop dismisses it.

### Profile Header
A card that clips a 96px Rose Blush → Rose Bright gradient banner. A 96px avatar with a 4px white ring overlaps the banner by half, above the centered name (Headline), a Rose Ink @handle and a Muted Gray join date.

## Do's and Don'ts

### Do:
- **Do** put every new content block on a Card White card with a 16px radius, the hairline ring and resting lift, stacked 12px apart in the 672px column.
- **Do** reuse the component classes (`btn` + variant, `input`, `label`, `card`, `link`, `alert-box`, `action`, `nav-row`) before composing new utility stacks. Extend `application.tailwind.css` when a new pattern repeats.
- **Do** keep Rose Ink for the single forward action on a surface. Give everything else Graphite, Ghost or a link.
- **Do** keep motion short and functional: 150ms for color and press changes, 300ms for enter, exit and removal (fade plus slight scale or slide).
- **Do** draw icons as inline SVG partials (`render "shared/icons/name", css: "size-5"`) in `currentColor`, so they inherit the text and hover tints.
- **Do** confirm destructive actions with the shared confirm dialog and report outcomes with a toast. Keep validation errors inline.
- **Do** give every interactive element the 2px Rose Glow focus outline.

### Don't:
- **Don't** add a second accent hue, or bring in Twitter's blue or its layout. Tweetable borrows the mechanics, not the identity.
- **Don't** use sharp corners on anything interactive, or give a nested element a larger radius than its container.
- **Don't** raise card shadows on hover or use heavy shadows on in-page content. Bigger shadows are for overlays only.
- **Don't** use the error reds for anything except deletion and failure.
- **Don't** set new small text in white on Rose Ink or in Muted Gray on Paper (see the Contrast Debt Rule).
- **Don't** use curly braces or Roboto outside the wordmark, or uppercase outside 12px labels.
- **Don't** reintroduce raster icons or hand-written CSS outside the Tailwind layers. `logo_app.png` and `default_avatar.png` are the only images.
