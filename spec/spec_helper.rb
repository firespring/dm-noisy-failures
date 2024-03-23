$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'dm_noisy_failures'

class Person
  include DataMapper::Resource
  has n, :memberships
  has n, :friends, 'Person', through: Resource

  property :id,    Serial
  property :name,  String, required: true
end

class Membership
  include DataMapper::Resource
  belongs_to :person
  property :id,        Serial
  property :person_id, Integer
  property :type,      String, required: true
end

class Address
  include DataMapper::Resource
  property :id, Serial
  property :street_address, String,  required: true
  property :city,           String,  required: true
  property :state,          String,  required: true
  property :zipcode,        Integer, required: true
end

DataMapper.setup(:default, 'sqlite3://' + File.join(File.dirname(__FILE__), 'test.db'))
DataMapper.finalize
DataMapper.auto_migrate!
