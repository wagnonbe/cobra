class SideDeterminer
  def self.determine_sides(player1, player2, stage)
    return nil unless player_has_pairings(player1, stage) || player_has_pairings(player2, stage)

    diff1 = player1.side_balance
    diff2 = player2.side_balance

    return :player1_is_corp if diff1 < diff2
    return :player1_is_runner if diff1 > diff2

    [:player1_is_corp, :player1_is_runner].sample
  end

  private

  def self.player_has_pairings(player, stage)
    player.pairings.reported.for_stage(stage).any?
  end
end
