require "foliate/config"

module Foliate
  class Pagination

    # @return [Integer]
    #   current page number
    attr_accessor :current_page

    # @return [Integer]
    #   number of records per page
    attr_accessor :per_page

    # @return [Integer]
    #   total number of records
    attr_accessor :total_records

    # @return [Symbol]
    #   originating controller
    attr_accessor :controller

    # @return [Symbol]
    #   originating controller action
    attr_accessor :action

    # @return [Hash]
    #   originating request query params
    attr_accessor :query_params

    # Computes the total number of pages based on +total_records+ and
    # +per_page+.
    #
    # @return [Integer]
    def total_pages
      (total_records / per_page.to_f).ceil
    end

    # Computes the record set offset based on +current_page+ and
    # +per_page+.
    #
    # @return [Integer]
    def offset
      (current_page - 1) * per_page
    end

    # Returns linking params for a specified +page_number+.  The
    # returned Hash is intended for use with +link_to+, +url_for+, etc.
    #
    # @example usage in view
    #   link_to "First", pagination.params_for_page(1)
    #   link_to "Last", pagination.params_for_page(pagination.total_pages)
    #
    # @param page_number [Integer]
    # @return [Hash]
    def params_for_page(page_number)
      { controller: controller, action: action, params: query_params.merge(
          Foliate.config.page_param => (page_number if page_number > 1)
      ) }
    end

    # Indicates if there is an expected page previous to the current
    # page.
    #
    # @return [Boolean]
    def prev?
      current_page > 1
    end

    # Indicates if there is an expected page beyond the current page.
    #
    # @return [Boolean]
    def next?
      current_page < total_pages
    end

    # Linking params for the previous page.  Returns nil if {#prev?} is
    # false.  See also {#params_for_page}.
    #
    # @example usage in view
    #   link_to_if pagination.prev?, "Previous", pagination.prev_page_params
    #
    # @return [Hash, nil]
    def prev_page_params
      params_for_page(current_page - 1) if prev?
    end

    # Linking params for the next page.  Returns nil if {#next?} is
    # false.  See also {#params_for_page}.
    #
    # @example usage in view
    #   link_to_if pagination.next?, "Next", pagination.next_page_params
    #
    # @return [Hash, nil]
    def next_page_params
      params_for_page(current_page + 1) if next?
    end

    # Path to the view partial.  This method exists to allow
    # +Pagination+ objects to be passed directly to +render+ calls in
    # the view.
    #
    # @example rendering view partial from view
    #   render @pagination
    #
    # @return [String]
    def to_partial_path
      "pagination/pagination"
    end

  end
end