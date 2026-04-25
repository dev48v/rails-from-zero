# STEP 9 — Add a favourite flag to books.
# Default false (NOT NULL) so the column never returns nil — UI code can use
# it directly without `unless` guards. Adding it as a separate migration (not
# editing the original CreateBooks) keeps history truthful: anyone running
# migrations from scratch sees exactly when this feature shipped.
class AddFavoriteToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :favorite, :boolean, default: false, null: false
  end
end
