# STEP 5 — Plain-Ruby service object that talks to Open Library.
#
# Why a "service" and not a model method?
#   - Book is a persistence concern; reaching the network is not.
#   - This class has zero gem dependencies — Net::HTTP and JSON ship with Ruby.
#   - It's trivial to swap or mock in tests later.
#
# Public API:
#   OpenLibraryService.search("tolkien") -> [ {title:, author:, olid:, ...}, ... ]
require "net/http"
require "json"
require "uri"

class OpenLibraryService
  ENDPOINT = "https://openlibrary.org/search.json"
  COVER_TEMPLATE = "https://covers.openlibrary.org/b/olid/%{olid}-M.jpg"

  # Limit the result count so the search page stays snappy. Open Library will
  # happily return thousands; we only render the first chunk.
  DEFAULT_LIMIT = 20

  # Open Library's response body has dozens of fields; we only care about a few.
  # Cherry-picking via `fields=` lets the API return a smaller payload.
  REQUESTED_FIELDS = %w[title author_name first_publish_year cover_edition_key edition_key key].freeze

  class << self
    def search(query, limit: DEFAULT_LIMIT)
      return [] if query.to_s.strip.empty?

      uri = URI(ENDPOINT)
      uri.query = URI.encode_www_form(
        q: query,
        limit: limit,
        fields: REQUESTED_FIELDS.join(",")
      )

      # `Net::HTTP.get_response` follows zero redirects, so be explicit when the
      # API moves. Today Open Library replies with 200 directly, but we wrap
      # this in a rescue to keep the controller from blowing up on transient
      # network errors — the user will simply see "no results".
      response = Net::HTTP.get_response(uri)
      return [] unless response.is_a?(Net::HTTPSuccess)

      docs = JSON.parse(response.body).fetch("docs", [])
      docs.map { |doc| normalise(doc) }.compact
    rescue StandardError
      []
    end

    private

    # Open Library returns inconsistent shapes depending on edition data. This
    # method flattens each document into a single predictable hash so views and
    # controllers don't have to think about the API quirks.
    def normalise(doc)
      olid = doc["cover_edition_key"] || (doc["edition_key"] || []).first
      return nil if olid.nil? && doc["title"].nil?

      {
        title: doc["title"],
        author: Array(doc["author_name"]).first,
        published_year: doc["first_publish_year"],
        olid: olid,
        cover_url: olid ? COVER_TEMPLATE % { olid: olid } : nil
      }
    end
  end
end
