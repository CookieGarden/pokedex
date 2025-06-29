namespace :pokemon do
  desc "初代のポケモンを取得"
  task fetch_data: :environment do
    puts "Starting to fetch Pokemon data..."
    Pokemon.fetch_and_save_pokemon_data(1, 151)
  end

  desc "指定した範囲のポケモンを取得"
  task :fetch_range, [ :start_id, :end_id ] => :environment do |task, args|
    start_id = args[:start_id]&.to_i || 1
    end_id = args[:end_id]&.to_i || 151

    puts "Fetching Pokemon data from #{start_id} to #{end_id}..."
    Pokemon.fetch_and_save_pokemon_data(start_id, end_id)
  end
end
