# STEP 9 — Five classics so a fresh clone is not empty.
# Run with: bin/rails db:seed
#
# Each entry uses a real Open Library OLID so the cover URL works out of the box.
# `find_or_initialize_by(olid:)` keeps the seed idempotent — running it twice
# updates the existing rows instead of inserting duplicates.
[
  {
    title: "The Hobbit",
    author: "J. R. R. Tolkien",
    olid: "OL26346997M",
    published_year: 1937,
    description: "Bilbo Baggins is swept into a quest to reclaim a treasure guarded by a dragon, alongside thirteen dwarves and a wizard.",
    favorite: true
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    olid: "OL24376853M",
    published_year: 1813,
    description: "Elizabeth Bennet navigates manners, upbringing, morality and marriage in early 19th-century England."
  },
  {
    title: "1984",
    author: "George Orwell",
    olid: "OL21733390M",
    published_year: 1949,
    description: "Winston Smith works for the Ministry of Truth in a totalitarian Oceania ruled by Big Brother — and quietly begins to rebel."
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    olid: "OL24322756M",
    published_year: 1960,
    description: "Through Scout Finch's eyes, a small-town Alabama lawyer defends a Black man falsely accused of a crime."
  },
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    olid: "OL26425451M",
    published_year: 1925,
    description: "Nick Carraway watches his mysterious neighbour Jay Gatsby chase the green light across the bay — and the past."
  }
].each do |attrs|
  book = Book.find_or_initialize_by(olid: attrs[:olid])
  book.update!(attrs.merge(cover_url: "https://covers.openlibrary.org/b/olid/#{attrs[:olid]}-M.jpg"))
end

puts "Seeded #{Book.count} books."
