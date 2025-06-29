require "faraday"

class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all
  end

  def show
    id = params[:id]

    # まずDBから探す
    @pokemon = Pokemon.find_by(id: id) || Pokemon.find_by(name: id)

    if @pokemon
      # DBにある場合はそれを使用
      @name = @pokemon.name
      @image_url = @pokemon.image_url
      @response = { "name" => @pokemon.name }
    else
      # DBにない場合はAPIから取得
      begin
        fetch_from_api(id)
      rescue StandardError
        # APIエラーまたは存在しないポケモンの場合は404を返す
        render file: "#{Rails.root}/public/404.html", status: :not_found and return
      end
    end
  end

  private

  def fetch_from_api(id)
    # ポケモン種族情報を取得（名前用）
    species_response = Faraday.get("https://pokeapi.co/api/v2/pokemon-species/#{id}/")

    # APIが404を返した場合はエラーを発生させる
    raise StandardError, "Pokemon not found" unless species_response.status == 200

    @response = JSON.parse(species_response.body)

    # ポケモン基本情報を取得（画像用）
    pokemon_response = Faraday.get("https://pokeapi.co/api/v2/pokemon/#{id}/")

    # APIが404を返した場合はエラーを発生させる
    raise StandardError, "Pokemon not found" unless pokemon_response.status == 200

    @pokemon_data = JSON.parse(pokemon_response.body)

    # 日本語名を取得
    if @response && @response["names"]
      name_entry = @response["names"].find { |name| name["language"]["name"] == "ja" }
      @name = name_entry ? name_entry["name"] : @response["name"]
    else
      @name = "不明"
    end

    # 画像URLを取得
    @image_url = @pokemon_data.dig("sprites", "other", "official-artwork", "front_default") ||
                 @pokemon_data.dig("sprites", "front_default")
  end
end
