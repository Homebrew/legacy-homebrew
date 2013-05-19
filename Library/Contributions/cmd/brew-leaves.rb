# Outputs formulae that are installed but are not a dependency for
# any other installed formula.
# See: http://github.com/mxcl/homebrew/issues/issue/1438

require 'formula'

def get_used_by(formulae)
  used_by = {}
  formulae.each do |f|
    next if f.nil? or f.deps.nil?

    f.deps.each do |dep|
      _deps = used_by[dep.to_s] || []
      _deps << f.name unless _deps.include? f.name
      used_by[dep.to_s] = _deps
    end
  end

  return used_by
end

installed = HOMEBREW_CELLAR.children.select { |pn| pn.directory? }.collect { |pn| pn.basename.to_s }
installed_formulae = installed.collect do |pn|
  begin
    Formula.factory(pn)
  rescue FormulaUnavailableError
    # Don't complain about directories from DIY installs
  end
end

deps_graph = get_used_by(installed_formulae)

installed.each do |name|
  deps = deps_graph[name] || []
  puts name unless deps.any? { |dep| installed.include? dep.to_s }
end
