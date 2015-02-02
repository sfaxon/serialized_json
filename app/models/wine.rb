class Wine < ActiveRecord::Base

  def varietals
    read_attribute(:varietals).map {|v| Varietal.new(v) }
  end

  class Varietal
    attr_accessor :name, :percentage

    def initialize(hash)
      @name          = hash['name']
      @percentage    = hash['percentage'].to_i
    end
  end
end
