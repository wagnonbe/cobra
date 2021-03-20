class Player < ApplicationRecord
  include Pairable

  belongs_to :tournament
  belongs_to :previous, class_name: 'Player', optional: true
  has_one :next, class_name: 'Player', foreign_key: :previous_id
  has_many :registrations, dependent: :destroy

  before_destroy :destroy_pairings

  scope :active, -> { where(active: true) }
  scope :dropped, -> { where(active: false) }
  scope :with_first_round_bye, -> { where(first_round_bye: true) }

  def pairings
    Pairing.for_player(self)
  end

  def non_bye_pairings
    pairings.non_bye
  end

  def side_imbalanced_pairings
    pairings.non_bye.single_sided
  end

  def opponents
    pairings.map { |p| p.opponent_for(self) }
  end

  # opponents we have played corp against
  def opponents_corped_against
    pairings.select { |p| p.side_for(self) == :corp || p.side == nil}.map { |p| p.opponent_for(self) }
  end

  # opponents we have played runner against
  def opponents_ran_against
    pairings.select { |p| p.side_for(self) == :runner || p.side == nil}.map { |p| p.opponent_for(self) }
  end

  def non_bye_opponents
    non_bye_pairings.map { |p| p.opponent_for(self) }
  end

  def points
    @points ||= pairings.reported.sum { |pairing| pairing.score_for(self) }
  end

  #TODO: add tests for this
  def side_balance
    @side_balance ||= side_imbalanced_pairings.reported.sum { |pairing| pairing.side_for(self) == :corp ? 1 : -1 }
  end

  def sos_earned
    @sos_earned ||= non_bye_pairings.reported.sum { |pairing| pairing.score_for(self) }
  end

  def drop!
    update(active: false)
  end

  def eligible_pairings
    pairings.completed
  end

  def seed_in_stage(stage)
    registrations.find_by(stage: stage).seed
  end

  def had_bye?
    pairings.bye.any?
  end

  def corp_identity_object
    Identity.find_or_initialize_by(name: corp_identity)
  end

  def runner_identity_object
    Identity.find_or_initialize_by(name: runner_identity)
  end

  private

  def destroy_pairings
    pairings.destroy_all
  end
end
