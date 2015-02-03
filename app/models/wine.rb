class Wine < ActiveRecord::Base

  def varietals
    read_attribute(:varietals).map {|v| Varietal.new(v) }
  end

  # ActionController params will come across as:
  # {"0"=>{"name"=>"foo", "percentage"=>"10"}, "1"=>{"name"=>"bar", "percentage"=>"90"}}
  def varietals_attributes=(attributes)
    varietals = []
    attributes.each do |index, attrs|
      next if '1' == attrs.delete("_destroy")
      attrs[:percentage] = attrs[:percentage].try(:to_i)
      varietals << attrs
    end
    write_attribute(:varietals, varietals)
  end

  class Varietal
    attr_accessor :name, :percentage

    def initialize(hash)
      hash = hash.symbolize_keys
      @name          = hash[:name]
      @percentage    = hash[:percentage].to_i
    end

    def persisted?() false; end
    def new_record?() false; end
    def marked_for_destruction?() false; end
    def _destroy() false; end
  end
end
