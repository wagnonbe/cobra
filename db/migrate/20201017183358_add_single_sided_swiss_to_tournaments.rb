class AddSingleSidedSwissToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :single_sided_swiss, :boolean
  end
end
