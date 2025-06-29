require "faraday"

class PokemonsController < ApplicationController
  def index
  end

  def show
    id = params[:id]

    # ポケモン種族情報を取得（名前用）
    species_response = Faraday.get("https://pokeapi.co/api/v2/pokemon-species/#{id}/")
    @response = JSON.parse(species_response.body)

    # ポケモン基本情報を取得（画像用）
    pokemon_response = Faraday.get("https://pokeapi.co/api/v2/pokemon/#{id}/")
    @pokemon_data = JSON.parse(pokemon_response.body)

    # 日本語名を取得
    if @response && @response["names"]
      japanese_name_entry = @response["names"].find { |name| name["language"]["name"] == "ja" }
      @name = japanese_name_entry ? japanese_name_entry["name"] : @response["name"]
    else
      @name = "不明"
    end

    # 画像URLを取得
    @image_url = @pokemon_data.dig("sprites", "other", "official-artwork", "front_default") || 
                 @pokemon_data.dig("sprites", "front_default")
  end
end
