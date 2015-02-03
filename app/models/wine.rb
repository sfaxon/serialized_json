class Wine < ActiveRecord::Base

  validate :varietals_percentage

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

  def build_varietal
    v = self.varietals.dup
    v << Varietal.new({name: '', percentage: 0})
    self.varietals = v
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

private
  def varietals_percentage
    if self.varietals.map(&:percentage).inject(:+) > 100
      self.errors.add(:varetals, "sum cannot be greater than 100")
    end
  end
end
