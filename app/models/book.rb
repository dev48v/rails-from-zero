# STEP 2 — Book model.
# Inherits from ApplicationRecord (which inherits from ActiveRecord::Base) so it
# gets the full Active Record toolkit for free: querying, validations, callbacks,
# associations. The class is intentionally tiny right now — Step 8 adds the
# validations, Step 9 adds the favourite toggle.
class Book < ApplicationRecord
  # Default scope: newest entries first. Used by Books#index so the most recently
  # added book shows at the top of the list without each controller having to
  # remember to sort. (default_scope is a tradeoff — it can surprise you when
  # writing complex queries — but for this beginner project the predictability
  # is worth more than the flexibility.)
  default_scope { order(created_at: :desc) }

  # STEP 8 — Validations.
  # These run on save/update; a failure populates errors.full_messages so the
  # form partial can list every problem at once.
  validates :title, presence: true, length: { maximum: 200 }
  validates :author, length: { maximum: 200 }
  validates :published_year,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 2100 },
            allow_nil: true
  # OLID is optional, but if it's present it must be unique — we don't want
  # the same book imported twice from search.
  validates :olid, uniqueness: true, allow_blank: true
end
