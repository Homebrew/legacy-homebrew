# Outputs formulae that are installed but are not a dependency for
# any other installed formula.
# See: http://github.com/mxcl/homebrew/issues/issue/1438

require 'formula'

def get_used_by(formulae)
  used_by = {}
  formulae.each do |f|
    f.deps.each do |dep|
      _deps = used_by[dep.to_s] || []
      _deps << f.name unless _deps.include? f.name
      used_by[dep.to_s] = _deps
    end
  end

  return used_by
end

installed = Formula.installed
names = installed.map(&:name)
deps_graph = get_used_by(installed)

names.each do |name|
  deps = deps_graph[name] || []
  puts name unless deps.any? { |dep| names.include? dep.to_s }
end
