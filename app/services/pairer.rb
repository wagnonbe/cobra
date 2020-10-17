class Pairer
  attr_reader :round
  delegate :stage, to: :round

  def initialize(round)
    @round = round
  end

  def pair!
    strategy.new(round).pair!
  end

  private

  def strategy
    if stage.format == 'swiss'
      return stage.tournament.single_sided_swiss ? PairingStrategies::SingleSidedSwiss : PairingStrategies::Swiss
    elsif stage.format == 'double_elim'
      return PairingStrategies::DoubleElim
    else
      return PairingStrategies::Swiss
    end
  end
end
