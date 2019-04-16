class Artist < ActiveRecord::Base
  has_many :albums
  has_many :artist_tags
  has_many :tags, through: :artist_tags

end