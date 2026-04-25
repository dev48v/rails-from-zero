Day 21 - I built a Goodreads-lite in 80 lines of Ruby (and you can read every commit)


🚀TechFromZero Series - RailsFromZero


This isn't a Hello World. It's a real MVC web app:
📐 Browser → Rails Router → Controller → OpenLibraryService → Open Library API → Active Record → SQLite → ERB View


🔗 The full code (with step-by-step commits you can follow):
https://github.com/dev48v/rails-from-zero


🧱 What I built (step by step):
1️⃣ rails new + Docker Compose so you don't need Ruby on your host

2️⃣ Book model + migration (title, author, cover, OLID, year, description)

3️⃣ Resourceful routes + BooksController with all seven CRUD actions

4️⃣ ERB layout + Bootstrap 5 CDN + index/show/new/edit views

5️⃣ OpenLibraryService — pure Net::HTTP + JSON, zero gem dependencies

6️⃣ Search page — live Open Library results with covers and authors

7️⃣ One-click import — search result becomes a row in your library

8️⃣ Validations, shared flash partial, OLID uniqueness so duplicates can't sneak in

9️⃣ Seeded classics + favourite heart toggle with redirect_back

🔟 Polish — favourite count, empty states, full README


💡 Every file has detailed comments explaining WHY, not just what. Written for any beginner who wants to learn Ruby on Rails by reading real code — with full clarity on each step.

👉 If you're a beginner learning Ruby on Rails, clone it and read the commits one by one. Each commit = one concept. Each file = one lesson. Built from scratch, so nothing is hidden.

🔥 This is Day 21 of a 50-day series. A new technology every day. Follow along!

🌐 See all days: https://dev48v.infy.uk/techfromzero.php

#TechFromZero #Day21 #RubyOnRails #LearnByDoing #OpenSource #BeginnerGuide #100DaysOfCode #CodingFromScratch
