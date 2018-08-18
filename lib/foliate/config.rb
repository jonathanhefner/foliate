module Foliate

  class Config
    # Default number of records to allot per page.  Defaults to +10+.
    #
    # @return [Integer]
    attr_accessor :default_per_page

    # Name of query param used to indicate page number.  Defaults to
    # +:page+.
    #
    # @return [Symbol]
    attr_accessor :page_param

    def initialize
      @default_per_page = 10
      @page_param = :page
    end
  end

  # Foliate global configuration object.
  #
  # @return [Foliate::Config]
  def self.config
    @config ||= Foliate::Config.new
  end

  # @param c [Foliate::Config]
  # @return [Foliate::Config]
  def self.config=(c)
    @config = c
  end

end
