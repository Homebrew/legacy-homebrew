# See: http://github.com/mxcl/homebrew/issues/issue/1438

require 'formula'
deps_graph = Formula.get_used_by
formulas = HOMEBREW_CELLAR.children.select { |pn| pn.directory? }.collect { |pn| pn.basename.to_s }
formulas.each do |name|
  deps = deps_graph[name] || []
  puts name if !deps.any? { |dep| formulas.include?(dep) }
end
