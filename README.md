# Tweetable

A simple Twitter-like app built with Ruby on Rails. Users can post short tweets, reply to them, and like them.

## Features

- Sign up and log in with email or GitHub (Devise + OmniAuth)
- Post tweets (max 140 characters)
- Reply to tweets
- Like and unlike tweets
- User profiles with avatars
- Member and admin roles

## Tech Stack

- Ruby 3.1.2
- Rails 7.0
- PostgreSQL
- Hotwire (Turbo + Stimulus) with importmaps
- Active Storage for avatars

## Getting Started

### Prerequisites

- Ruby 3.1.2
- PostgreSQL
- Bundler

### Setup

```bash
git clone git@github.com:marlonsalazarg/tweetable-marlonsalazarg.git
cd tweetable-marlonsalazarg
bundle install
cp .env.example .env
bundle exec rails db:create db:migrate db:seed
bundle exec rails server
```

Then open http://localhost:3000.

### GitHub Sign-In

Create a GitHub OAuth app and add its credentials to `.env`:

```
GITHUB_KEY=your_client_id
GITHUB_SECRET=your_client_secret
```

### Demo Accounts

The seed data creates demo users. All of them use the password `123456`. For example, `admin@mail.com` is an admin.

> Note: running `db:seed` deletes the existing users, tweets, and likes.

## Linting

```bash
bundle exec rubocop
```
