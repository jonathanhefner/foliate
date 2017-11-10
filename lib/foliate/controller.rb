require "foliate/config"
require "foliate/pagination"

module Foliate
  module Controller

    # Paginates +records+, and returns the current page of records
    # according to <code>params[Foliate.config.page_param]</code>
    # (typically, <code>params[:page]</code>).  Also sets the
    # +@pagination+ instance variable for use in the view (see
    # {Foliate::Pagination}).
    #
    # Returns an ActiveRecord::Relation if +records+ is an
    # ActiveRecord::Relation.  Returns an Array if +records+ is an
    # Array.
    #
    # By default, allots <code>Foliate.config.default_per_page</code>
    # number of records per page.  This can be overridden by specifying
    # +per_page:+.
    #
    # By default, if +records+ is an ActiveRecord::Relation, computes
    # the total number of pages by performing a SQL count query.  If the
    # underlying table is very large, this query could have a noticeable
    # performance cost.  This can be circumvented by specifying
    # +total_records:+, using an estimated or cached record count.
    #
    # @example basic pagination
    #   @posts = paginate(Post)
    #
    # @example paginated search
    #   @posts = paginate(Post.where(status: params[:show_only]))
    #
    # @example user-specified per_page
    #   @posts = paginate(Post, per_page: params[:at_a_time])
    #
    # @example simple cached count
    #   count = Rails.cache.fetch("Post/count", expires_in: 5.minutes){ Post.count }
    #   @posts = paginate(Post, total_records: count)
    #
    # @param records [ActiveRecord::Relation, Array]
    # @param per_page [Integer, String]
    # @param total_records [Integer]
    # @return [ActiveRecord::Relation, Array]
    def paginate(records, per_page: nil, total_records: nil)
      @pagination = Foliate::Pagination.new.tap do |p|
        p.current_page = [params[Foliate.config.page_param].to_i, 1].max
        p.per_page = per_page.try(&:to_i) || Foliate.config.default_per_page
        p.total_records = total_records || (records.is_a?(Array) ?
          records.length : records.unscope(:limit).unscope(:offset).count)
        p.controller = params[:controller]
        p.action = params[:action]
        p.query_params = request.query_parameters.except(Foliate.config.page_param)
      end

      records.is_a?(Array) ?
        records[@pagination.offset, @pagination.per_page].to_a :
        records.limit(@pagination.per_page).offset(@pagination.offset)
    end

  end
end
