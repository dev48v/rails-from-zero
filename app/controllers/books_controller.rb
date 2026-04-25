# STEP 3 — BooksController.
# Every action here is one HTTP entry point. Rails calls the action method,
# instance variables (@book, @books) are passed automatically to the matching
# ERB view, and the view is rendered unless we call `redirect_to` or `render`
# explicitly.
#
# Step 6 will add #search; Step 7 will add #import. Stubs are here from day one
# so the routes from Step 3 do not 404 — but they just render placeholders for
# now and gain real bodies later.
class BooksController < ApplicationController
  # before_action runs before every listed action. set_book centralises the
  # `@book = Book.find(params[:id])` lookup so each action below stays focused
  # on its own job.
  before_action :set_book, only: %i[show edit update destroy toggle_favorite]

  # GET /books — list every book. The default_scope on Book sorts newest-first.
  def index
    @books = Book.all
  end

  # GET /books/:id
  def show
  end

  # GET /books/new — render an empty form.
  def new
    @book = Book.new
  end

  # GET /books/:id/edit
  def edit
  end

  # POST /books — handle the form from #new.
  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book added to your library."
    else
      # Re-render the form with errors. Status 422 is the convention for
      # validation failures so Turbo replaces the page properly.
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /books/:id — handle the form from #edit.
  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book removed."
  end

  # STEP 9 — PATCH /books/:id/toggle_favorite.
  # Flip the boolean and bounce back to wherever the request came from so the
  # heart button can sit on either the show page or the index without each
  # caller having to know what URL to redirect to.
  def toggle_favorite
    @book.update(favorite: !@book.favorite)
    redirect_back fallback_location: @book,
                  notice: @book.favorite ? "Marked as favourite." : "Removed favourite."
  end

  # STEP 6 — GET /search → live Open Library results.
  # Empty queries skip the network call (the service short-circuits anyway, but
  # being explicit keeps the page fast on first visit).
  def search
    @query = params[:q].to_s.strip
    @results = @query.empty? ? [] : OpenLibraryService.search(@query)
  end

  # STEP 7 — POST /books/import.
  # Accepts the hidden fields submitted from a search result card and stores
  # them as a Book row. We don't re-call Open Library here — the data the user
  # already saw on the search page is exactly what we save, which keeps the
  # import deterministic.
  def import
    book = Book.new(import_params)
    if book.save
      redirect_to book, notice: "Added \"#{book.title}\" to your library."
    else
      # Most failures here are "you already imported this OLID" or a missing
      # title (defensive: the form supplies it, but a malicious POST might not).
      redirect_to search_path(q: params[:q]), alert: book.errors.full_messages.to_sentence
    end
  end

  private

  # Looks up the requested book once for any action that needs it.
  def set_book
    @book = Book.find(params[:id])
  end

  # Strong Parameters — only allow the fields we actually use into mass
  # assignment. Anything not whitelisted (like an `admin: true` attribute
  # someone might try to sneak in) is silently dropped.
  def book_params
    params.require(:book).permit(:title, :author, :cover_url, :olid,
                                 :published_year, :description)
  end

  # Import params come straight from the search-result form (no `book` wrapper),
  # so they need their own permit list. STEP 7.
  def import_params
    params.permit(:title, :author, :cover_url, :olid, :published_year)
  end
end
