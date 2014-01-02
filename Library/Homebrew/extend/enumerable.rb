module Enumerable
  def group_by
    inject({}) do |h, e|
      h.fetch(yield(e)) { |k| h[k] = [] } << e; h
    end
  end unless method_defined?(:group_by)
end
