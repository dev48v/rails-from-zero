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
end
