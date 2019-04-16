# Requiring the gems that we need
require 'active_record'
require 'pg'
require 'pry'
require 'faker'

# Requiring the classes aka models
require_relative './models/album'
require_relative './models/artist_tag'
require_relative './models/artist'
require_relative './models/tag'
require_relative './models/track'

# Create the setup for the database
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  user: 'your user',
  password: 'your password',
  database: 'your database'
)

# Create the schema for the database
ActiveRecord::Schema.define do

  puts "Creating Table Artists --------------"
  create_table :artists, force: true do |t|
    t.string :name
  end

  puts "Creating Table Albums --------------"
  create_table :albums, force: true do |t|
    t.string :title
    t.integer :year
    t.references :artist, foreign: true
  end

  puts "Creating Table Tracks --------------"
  create_table :tracks, force: true do |t|
    t.string :title
    t.integer :number
    t.references :album, foreign: true
  end

  puts "Creating Table Tags --------------"
  create_table :tags, force: true do |t|
    t.string :name
  end

  puts "Creating Table ArtistTags -------------"
  create_table :artist_tags, force: true do |t|
    t.references :artist, foreign: true
    t.references :tag, foreign: true
  end

  puts "Adding Artists ----------------"

  20.times do
    Artist.create!(name: Faker::Music.band)
  end

  puts "Adding Albums ---------------"

  Artist.all.each do |artist|
  
    3.times do
      artist.albums.create!(title: Faker::Music.album, year: rand(1995..2019))
    end
  
  end

  puts "Adding Tracks ------------"

  Album.all.each do |album|
    5.times do |nb|
      album.tracks.create!(title: Faker::Music::Phish.song, number: nb + 1)
    end
  end

  puts "Adding tags -------------"

  20.times do
    Tag.create!(name: Faker::Music.genre)
  end

  puts "Adding artist tags"

  30.times do
    ArtistTag.create!(artist_id: Artist.all.sample.id, tag_id: Tag.all.sample.id)
  end

  # Allow us to stop and interact with the database with Active Record
  binding.pry

end

