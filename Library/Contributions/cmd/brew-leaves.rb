# Outputs formulae that are installed but are not a dependency for
# any other installed formula.
# See: http://github.com/mxcl/homebrew/issues/issue/1438

require 'formula'
require 'set'
require 'tab'

installed = Formula.installed
deps_of_installed = Set.new

installed.each do |f|
  deps = []

  f.deps.each do |dep|
    if dep.optional? || dep.recommended?
      tab = Tab.for_formula(f)
      deps << dep.name if tab.with?(dep.name)
    else
      deps << dep.name
    end
  end

  deps_of_installed.merge(deps)
end

installed.each do |f|
  puts f.name unless deps_of_installed.include? f.name
end
