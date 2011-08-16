# Builds binary brew package
require 'cmd/install'

destination = HOMEBREW_PREFIX + "Bottles"
Dir.mkdir destination unless File.directory? destination

ARGV.each do|formula|
  # Get the latest version
  version = `brew list --versions #{formula}`.split.last

  if version.nil?
    onoe "Formula not installed: #{formula}"
    next
  end

  source = HOMEBREW_CELLAR + formula + version
  filename = "#{formula}-#{version}-bottle.tar.gz"
  ohai "Bottling #{formula} #{version}..."
  HOMEBREW_CELLAR.cd do
    # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
    # or an uncompressed tarball (and more bandwidth friendly).
    safe_system 'tar', 'czf', "#{destination}/#{filename}", "#{formula}/#{version}"
    sha1 = Pathname.new("#{destination}/#{filename}").sha1
    ohai "Bottled #{filename}"
    ohai "SHA1 #{sha1}"
  end
end
