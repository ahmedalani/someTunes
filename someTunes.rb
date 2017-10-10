require 'active_record'
require 'faker'

#ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :host => "localhost",
  :database => "sqlite.db"
)

ActiveRecord::Schema.define do
  drop_table :genres, if_exists: true
  drop_table :artists, if_exists: true
  drop_table :albums, if_exists: true
  drop_table :tracks, if_exists: true
  
  create_table :genres do |table|
    table.column :name, :string, null: false
    table.column :decade, :integer, null: false
    table.timestamps null: false
  end

  create_table :artists do |table|
    table.column :name, :string, null: false
    table.column :planet, :string, null: false
    table.references :genre, index: true, foreign: true, null: false
    table.timestamps null: false
  end

  create_table :albums do |table|
    table.column :title, :string, null: false
    table.references :artist, index: true, foreign: true, null: false
    table.timestamps null: false
  end

  create_table :tracks do |table|
    table.column :track_number, :integer, null: false
    table.column :title, :string, null: false
    table.references :album, index: true, foreign: true, null: false
    table.timestamps null: false
  end
end

class Genre < ActiveRecord::Base
  has_many :artists
  validates_presence_of :name, :decade
end

class Artist < ActiveRecord::Base
  has_many :albums
  belongs_to :genre
  validates_presence_of :name, :planet, :genre
end

class Album < ActiveRecord::Base
  has_many :tracks
  belongs_to :artist
  validates_presence_of :title, :artist

end

class Track < ActiveRecord::Base
  belongs_to :album
  validates_presence_of :track_number, :title, :album
end

genre = Genre.create!(
  name: 'Celectial Rock',
  decade: 70
)

1.upto(10) do
  Artist.create!(
    name: Faker::Name.name,
    planet: Faker::HitchhikersGuideToTheGalaxy.planet,
    genre: genre
  )
end

Artist.all.each do |artist|
  Album.create!(
    title: Faker::LeagueOfLegends.quote,
    artist: artist
  )
end

Album.all.each do |album|
  1.upto(10) do |track_num|
    Track.create!(
      track_number: track_num,
      title: Faker::Overwatch.quote,
      album: album
    )
  end
end

# TODO
# 1) what is wrong with the output of this:
# Album.first.tracks.each do |t|
#   p t
# end

# 2) This shouldn't work, no planet specified!
# bad_artist = Artist.create!(name: 'bob' , planet: 'neptune')
# p bad_artist

# 3) Add another entity 'genre'
# it should be a parent of artist

