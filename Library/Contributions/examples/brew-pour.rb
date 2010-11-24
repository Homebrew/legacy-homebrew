require 'formula.rb'
require 'utils.rb'

# Extracts binary brew package

ARGV.each do|arg|
  formula = Formula.factory(arg)
  if not formula.bottle
    ohai "We don't have a bottle of #{arg}"
    next
  end

  if formula.installed?
    ohai "Formula already installed: #{formula.prefix}"
    next
  end

  cache = HOMEBREW_CACHE + 'Bottles'
  filename = formula.name + '-' + formula.version + '-bottle.tar.gz'
  FileUtils.mkdir_p(cache)
  cache.cd do
    ohai "Downloading #{formula.bottle}"
    curl "-o", filename, formula.bottle
  end

  HOMEBREW_CELLAR.cd do
    ohai "Pouring #{arg}"
    safe_system 'tar', 'zxf', cache + filename
  end
end
