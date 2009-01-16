class DynamicSifter

  # The primary way of doing your search-filter request
  #
  # * <tt>model</tt> - an <tt>ActiveRecord</tt> class
  # * <tt>args</tt> - a hash of arguments.  These are the same parameters that you pass to <tt>ActiveRecord::Base#find</tt>, with one addition:
  #   *<tt>:filters</tt> - used to specify the <tt>named_scopes</tt> to use to filter the search.  Can either pass a <tt>String</tt> for one filter, otherwise an <tt>Array</tt> of symbols.
  def self.search(model, args={})
    self.new(model, args).search
  end

  def initialize(model, args={})
    @model = model
    @scopes = model.scopes.map { |k,v| k.to_sym }
    @filters = args.delete(:filters) || []
    @filters = @filters.to_a if @filters.kind_of? String
    @options = args
  end

  def search
    apply_filters(@model.scoped( @options ))
  end

private

  def apply_filters(results)
    @filters.inject(results) { |result,filter| result.send(filter.to_sym) if filter_exists?(filter) }
  end

  def filter_exists?(filter)
    @scopes.include?(filter.to_sym)
  end

  class DynamicSifterError < RuntimeError; end

end
