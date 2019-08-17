class Skill < ApplicationRecord
  has_many :cards, dependent: :delete_all
  belongs_to :user
  belongs_to :general_skill

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 50 }

  scope :of_current_user, ->(current_user) { current_user.skills }
  scope :of_general_skill, ->(gs_id) { joins(:general_skill).where(general_skills: {id: gs_id}) unless gs_id.blank? }

  scope :order_asc_by_total_num_of_cards, -> { select('skills.*', 'count(cards.id) AS cds').left_joins(:cards)
                                                .group('skills.id').order('cds asc') }
  scope :order_desc_by_total_num_of_cards, -> { select('skills.*', 'count(cards.id) AS cds').left_joins(:cards)
                                                 .group('skills.id').order('cds desc') }
  scope :order_asc_by_total_score_of_cards, -> { select('skills.*', 'sum(cards.score) AS cds').left_joins(:cards)
                                                  .group('skills.id').order('cds asc') }
  scope :order_desc_by_total_score_of_cards, -> { select('skills.*', 'sum(cards.score) AS cds').left_joins(:cards)
                                                   .group('skills.id').order('cds desc') }
end
