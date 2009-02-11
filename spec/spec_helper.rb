require 'rubygems'
require 'spec'
require 'active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'dynamic_sifter'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:')

ActiveRecord::Schema.define do

  create_table :bottles do |bottle|
    bottle.references :wine
    bottle.date :year
    bottle.integer :base_price
  end

  create_table :wines do |wine|
    wine.references :region
    wine.string :name, :kind
    wine.text :description
  end

  create_table :regions do |region|
    region.string :name
    region.text :description
  end

end

class Bottle < ActiveRecord::Base
  belongs_to :wine
end

class Wine < ActiveRecord::Base
  has_many :bottles
  belongs_to :region
end

class Region < ActiveRecord::Base
  has_many :wines
end