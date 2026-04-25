# STEP 2 — Create the books table.
# Migrations are versioned database changes. Each one is a Ruby class with a
# `change` method; Rails runs them in timestamp order so the schema history is
# replayable from scratch on any fresh database.
class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title          # the book's title, shown everywhere
      t.string :author         # author name as a flat string (no Author table yet — keep it simple)
      t.string :cover_url      # full URL to a cover image (built from olid in Step 5)
      t.string :olid           # Open Library ID, e.g. "OL45804W". Lets us deep-link back to openlibrary.org
      t.integer :published_year
      t.text :description      # text instead of string so long blurbs are not truncated to 255 chars

      # Adds created_at + updated_at, automatically maintained by Active Record.
      # Useful for "newest first" sorting and audit trails.
      t.timestamps
    end
  end
end
