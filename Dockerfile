# STEP 1 — Dev container so you do not need Ruby on your host machine.
# One image, one command (`docker compose up`), and Rails runs.

FROM ruby:3.3

# build-essential + sqlite3 dev headers are needed to compile native gems.
RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends build-essential libsqlite3-dev sqlite3 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only Gemfile* first so `bundle install` is cached when only app code changes.
COPY Gemfile Gemfile.lock* ./
RUN bundle install

# Then copy the rest of the app. docker-compose mounts the project over this in dev,
# but having it baked in means `docker run` works on its own too.
COPY . .

EXPOSE 3000

# 0.0.0.0 binds to every interface so the host browser can reach the container.
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
