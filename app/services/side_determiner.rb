class SideDeterminer
  def self.determine_sides(player1, player2, stage)
    return nil if player1 == Swissper::Bye || player2 == Swissper::Bye

    #TODO: this currently carries over side_balance into cut 
    #When this logic is extracted into the actual pairing algorithm, revert this change or make it stage-friendly
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
