require 'active_record'
require 'faker'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :host => "localhost",
  :database => "sqlite.db"
)

ActiveRecord::Schema.define do
  drop_table :artists, if_exists: true
  drop_table :albums, if_exists: true
  drop_table :tracks, if_exists: true

  create_table :artists do |table|
    table.column :name, :string, null: false
    table.column :planet, :string, null: false
    table.timestamps null: false
  end

  create_table :albums do |table|
    table.column :title, :string, null: false
    table.references :artist, index: true, foreign: true
    table.timestamps null: false
  end

  create_table :tracks do |table|
    table.column :track_number, :integer, null: false
    table.column :title, :string, null: false
    table.references :album, index: true, foreign: true
    table.timestamps null: false
  end
end

class Artist < ActiveRecord::Base
  has_many :albums
end

class Album < ActiveRecord::Base
  has_many :tracks
  belongs_to :artist
end

class Track < ActiveRecord::Base
  belongs_to :album
end

1.upto(10) do
  Artist.create!(
    name: Faker::Name.name,
    planet: Faker::HitchhikersGuideToTheGalaxy.planet
  )
end

Artist.all.each do |artist|
  Album.create!(
    title: Faker::LeagueOfLegends.quote,
    artist: artist
  )
end

Album.all.each do |album|
  1.upto(10) do
    Track.create!(
      track_number: 1,
      title: Faker::Overwatch.quote,
      album: album
    )
  end
end
