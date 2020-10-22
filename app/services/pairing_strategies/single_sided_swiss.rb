module PairingStrategies
    class SingleSidedSwiss < Base
      # TODO: update with actual single sided swiss pairing
      BYE_WINNER_SCORE = 3
      BYE_LOSER_SCORE = 0
  
      def pair!
        assign_byes!
  
        paired_players.each do |pairing|
          round.pairings.create(pairing_params(pairing))
        end
  
        apply_numbers!(PairingSorters::Ranked)
      end
  
      private
  
      def assign_byes!
        players_with_byes.each do |player|
          round.pairings.create(
            player1: player,
            player2: nil,
            score1: BYE_WINNER_SCORE,
            score2: BYE_LOSER_SCORE
          )
        end
      end
  
      def paired_players
        return @paired_players ||= players_to_pair.to_a.shuffle.in_groups_of(2, Swissper::Bye) if first_round?
        #TODO: look into implementing BigSwiss changes - are these for performance? what about them is needed
  
        @paired_players ||= Swissper.pair(
          players_to_pair.to_a,
          delta_key: :points,
          exclude_key: :unpairable_opponents
        )
      end
  
      def pairing_params(pairing)
        {
          player1: player_from_pairing(pairing[0]),
          player2: player_from_pairing(pairing[1]),
          score1: auto_score(pairing, 0),
          score2: auto_score(pairing, 1),
          side: SideDeterminer.determine_sides(player_from_pairing(pairing[0]), player_from_pairing(pairing[1]), stage)
        }
      end
  
      def player_from_pairing(player)
        player == Swissper::Bye ? nil : player
      end
  
      def auto_score(pairing, player_index)
        return unless pairing[0] == Swissper::Bye || pairing[1] == Swissper::Bye
  
        pairing[player_index] == Swissper::Bye ? BYE_LOSER_SCORE : BYE_WINNER_SCORE
      end
  
      def apply_numbers!(sorter)
        sorter.sort(round.pairings.non_bye).each_with_index do |pairing, i|
          pairing.update(table_number: i + 1)
        end
  
        non_bye_tables = round.pairings.non_bye.count
        round.pairings.bye.each_with_index do |pairing, i|
          pairing.update(table_number: i + non_bye_tables + 1)
        end
      end
  
      def players_with_byes
        return players.with_first_round_bye if first_round?
  
        []
      end
  
      def players_to_pair
        @players_to_pair ||= players - players_with_byes
      end
  
      def first_round?
        (stage.rounds - [round]).empty?
      end
    end
  end
  