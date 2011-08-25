# Builds binary brew package
require 'cmd/install'

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
  destination = Pathname.pwd
  HOMEBREW_CELLAR.cd do
    # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
    # or an uncompressed tarball (and more bandwidth friendly).
    safe_system 'tar', 'czf', destination/filename, "#{formula}/#{version}"
    puts "./#{filename}"
    puts "bottle 'https://downloads.sf.net/project/machomebrew/Bottles/#{filename}'"
    puts "bottle_sha1 '#{(destination/filename).sha1}'"
  end
end
