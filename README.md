# rails-from-zero

A real Ruby on Rails 7 web app, built from scratch — Book Library backed by the
[Open Library](https://openlibrary.org/dev/docs/api/search) public API.
Search any book in existence, save the ones you care about, mark favourites.
Every commit on `master` is one teaching step you can read in order.

## Quick start (60 seconds)

You only need Docker. No Ruby on the host.

```bash
git clone https://github.com/dev48v/rails-from-zero.git
cd rails-from-zero
docker compose up --build
```

In a second terminal, set up the database (first time only):

```bash
docker compose exec web bin/rails db:create db:migrate db:seed
```

Open <http://localhost:3000> — you will land on the library, with five seeded
classics. Click **Search** in the navbar to pull live results from Open Library.

## What you will learn

| Concept | Where in the code |
|---|---|
| Rails MVC request cycle | `app/controllers/books_controller.rb` |
| Active Record + migrations | `app/models/book.rb`, `db/migrate/*` |
| Resourceful routes | `config/routes.rb` |
| ERB views + partials | `app/views/books/*.html.erb` |
| Plain-Ruby service objects | `app/services/open_library_service.rb` |
| Strong Parameters | `book_params` in the controller |
| Validations + flash messages | `Book` model + `_flash.html.erb` |
| Seeds | `db/seeds.rb` |

## Step-by-step guide

Read the commits in order — each one is a self-contained lesson.

1. **rails new + skeleton** — generated the project with `rails new . --database=sqlite3`,
   then wrote a Dockerfile and a docker-compose.yml so you can run Rails without
   installing Ruby. Replaced the default README with the one you are reading.

2. **Book model + migration** — `bin/rails g model Book ...` created the `books`
   table. Six columns: `title`, `author`, `cover_url`, `olid` (Open Library ID),
   `published_year`, `description`.

3. **BooksController + resourceful routes** — generated the controller and wired
   `resources :books` in `config/routes.rb`. CRUD actions follow the standard
   seven-action Rails pattern, so URL helpers like `books_path` and `book_path`
   come for free.

4. **ERB layout + Bootstrap CDN + views** — wrote `application.html.erb` with a
   navbar and a Bootstrap CDN link, then `index`, `show`, `new`, `edit` views and
   a `_form.html.erb` partial reused by `new` and `edit`. CDN means zero JS build.

5. **OpenLibraryService** — a plain Ruby class in `app/services/`. Calls the
   public Open Library Search API with `Net::HTTP` and `JSON.parse`. Returns an
   array of normalised hashes the controller can iterate over directly. No gem.

6. **Search action + form** — `GET /search` renders a search box and a result
   grid. Each result shows a cover image, title, author, and an **Add to library**
   button. Cover URLs are built from each book's OLID.

7. **Import-from-search action** — `POST /books/import` accepts the hidden fields
   from the search result form, calls `Book.create!`, then redirects to the new
   book's show page. One click moves a book from "the internet" to "my library".

8. **Validations + flash messages** — added `validates :title, presence: true,
   length: { maximum: 200 }` and similar rules. A shared `_flash.html.erb`
   partial renders Bootstrap alerts for `:notice` and `:alert`.

9. **Seeds + favourite toggle** — `db/seeds.rb` inserts five classics so a fresh
   clone is not empty. Added a `favorite:boolean` column with a heart-button
   toggle on the show page.

10. **Polish + this README** — empty-state messages on the index and search
    pages, README rewritten with the section you are reading, final cleanup.

## Project layout

```
app/
  controllers/books_controller.rb   - HTTP entry points
  models/book.rb                    - persistence + validations
  services/open_library_service.rb  - external API call
  views/books/                      - HTML templates
  views/layouts/application.html.erb- shared shell + navbar
config/routes.rb                    - URL -> controller wiring
db/migrate/                         - schema history
db/seeds.rb                         - sample data
```

## Running tests

This project is intentionally test-free — testing is its own day in the
TechFromZero series. Trust the small surface area and click around.

## License

MIT — do whatever you want with it. Built for learning.
