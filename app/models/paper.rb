class Paper < ApplicationRecord
  belongs_to :user
  belongs_to :general_skill, optional: true

  validates :title, length: { maximum: 200 }
  validates :content, length: { maximum: 500 }
  validates :url, presence: true, length: { maximum: 500 }
  validates :user_id, presence: true

  scope :of_current_user, ->(current_user) { current_user.papers }

  def status_text
    case status
    when PAPER_STATUS_PENDING
      "pending"
    when PAPER_STATUS_CONFIRMED
      "confirmed"
    when PAPER_STATUS_DONE
      "done"
    end
  end
end
