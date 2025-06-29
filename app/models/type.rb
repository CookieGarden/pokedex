class Type < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :pokemons

  def self.fetch_and_save_type_data
    require "faraday"

    type_data_array = []
    (1..18).each do |id|
      begin
        response = Faraday.get("https://pokeapi.co/api/v2/type/#{id}")
        if response.success?
          type_data = JSON.parse(response.body)
          type_data_array << {
            name: type_data["name"],
            created_at: Time.current,
            updated_at: Time.current
          }
        end

        sleep(0.5)

      rescue => e
        puts "idが#{id}のタイプの取得に失敗しました: #{e.message}"
        next
      end
    end

    if type_data_array.any?
      puts "#{type_data_array.size}個のタイプをDBに保存中..."

      # upsert_allで既存データは更新、新規データは挿入
      Type.upsert_all(
        type_data_array,
        unique_by: :name,
        update_only: [ :updated_at ]
      )

      puts "Typeデータの保存が完了しました。"
    else
      puts "取得したTypeデータがありませんでした。"
    end
  end
end
