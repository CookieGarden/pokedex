class Pokemon < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.fetch_and_save_pokemon_data(start_id = 1, end_id = 151)
    require "faraday"

    pokemon_data_array = []

    (start_id..end_id).each do |pokemon_id|
      begin
        puts "idが#{pokemon_id}のポケモンを取得中..."

        # ポケモン種族情報を取得（名前用）
        species_response = Faraday.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_id}/")
        species_data = JSON.parse(species_response.body)

        # ポケモン基本情報を取得（画像用）
        pokemon_response = Faraday.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_id}/")
        pokemon_data = JSON.parse(pokemon_response.body)

        name = extract_name(species_data)

        image_url = pokemon_data.dig("sprites", "other", "official-artwork", "front_default") ||
                   pokemon_data.dig("sprites", "front_default")

        pokemon_data_array << {
          name:,
          image_url:,
          created_at: Time.current,
          updated_at: Time.current
        }

        sleep(0.5)

      rescue => e
        puts "idが#{pokemon_id}のポケモンの取得に失敗しました: #{e.message}"
        next
      end
    end

    # バルクインサート/アップサート実行
    if pokemon_data_array.any?
      puts "#{pokemon_data_array.size}匹のポケモンをDBに保存中..."

      # upsert_allで既存データは更新、新規データは挿入
      Pokemon.upsert_all(
        pokemon_data_array,
        unique_by: :name,
        update_only: [ :image_url, :updated_at ]
      )
    end

    puts "取得完了!"
  end

  private

  def self.extract_name(species_data)
    return "不明" unless species_data && species_data["names"]

    name_entry = species_data["names"].find { |name| name["language"]["name"] == "ja" }
    name_entry ? name_entry["name"] : species_data["name"] || "不明"
  end
end
