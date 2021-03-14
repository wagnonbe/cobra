class StandingRow < ApplicationRecord
  belongs_to :stage
  belongs_to :player

  default_scope { order(position: :asc) }

  delegate :name, :corp_identity, :runner_identity, :manual_seed, to: :player

  def corp_identity
    identity(player.corp_identity)
  end

  def runner_identity
    identity(player.runner_identity)
  end

  def side_balance
    return "Even" if player.side_balance == 0
    favored = player.side_balance > 0 ? "Corp" : "Runner"
    "#{favored}: +#{player.side_balance.abs}"
  end

  private

  def identity(id)
    Identity.find_or_initialize_by(name: id)
  end
end
