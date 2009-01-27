class DynamicSifter

  # The primary way of doing your search-filter request
  #
  # * <tt>model</tt> - an <tt>ActiveRecord</tt> class
  # * <tt>args</tt> - a hash of arguments.  These are the same parameters that you pass to <tt>ActiveRecord::Base#find</tt>, with one addition:
  #   *<tt>:filters</tt> - used to specify the <tt>named_scopes</tt> to use to filter the search.  Can pass either a:
  #     *<tt>String</tt> for one filter
  #     *<tt>Array</tt> of symbols for multiple symbols
  #     *<tt>Hash</tt> of symbols of Arrays, where the Arrays contain arguments to the scope (e.g. { :author_and_publisher => [arg1, arg2] }) 
  #
  # Examples:
  # DynamicSifter.search()
  def self.search(model, args={})
    self.new(model, args).search
  end

  def initialize(model, args={})
    @model = model
    @scopes = model.scopes.map { |k,v| k.to_sym }
    @filters = initialize_filters(args.delete(:filters))
    @options = args
  end

  def search
    apply_filters(@model.scoped( @options ))
  end

private

  def apply_filters(results)
    @filters.inject(results) { |result,data|
      filter, args = data
      result.send(filter.to_sym, *args) if filter_exists?(filter)
    }
  end

  def initialize_filters(filters)
    case filters.class
    when String: filters.to_a
    when Hash: filters.to_a
    else
      filters ? 
        filters : []
    end
  end

  def filter_exists?(filter)
    @scopes.include?(filter.to_sym)
  end

  class DynamicSifterError < RuntimeError; end

end
