module Foliate

  class Config
    # @return [Integer]
    #   default number of records to allot per page (defaults to +10+)
    attr_accessor :default_per_page

    # @return [Symbol]
    #   URL query param name for specifying page numbers (defaults to
    #   +:page+)
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
  def self.config=(c)
    @config = c
  end

end
