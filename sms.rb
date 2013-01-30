require 'data_mapper'

#Data model for received SMS

class SMS
  include DataMapper::Resource
  property :id, Serial
  property :body, Text
  property :from, String
  property :to, String
  property :created_at, DateTime
end