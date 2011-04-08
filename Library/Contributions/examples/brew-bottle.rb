# Builds binary brew package
require 'cmd/install'

Homebrew.install_formulae ARGV.formulae

destination = HOMEBREW_PREFIX + "Bottles"
if not File.directory?(destination)
  Dir.mkdir destination
end

ARGV.each do|formula|
  # Get the latest version
  version = `brew list --versions #{formula}`.split.last
  source = HOMEBREW_CELLAR + formula + version
  filename = formula + '-' + version + '-bottle.tar.gz'
  ohai "Bottling #{formula} #{version}..."
  HOMEBREW_CELLAR.cd do
    # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
    # or an uncompressed tarball (and more bandwidth friendly).
    safe_system 'tar', 'czf', "#{destination}/#{filename}", "#{formula}/#{version}"
  end
  ohai "Bottled #{filename}"
end
