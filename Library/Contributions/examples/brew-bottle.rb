# Builds binary brew package
require 'tab'

ARGV.each do|formula|
  # Get the latest version
  version = `brew list --versions #{formula}`.split.last

  if version.nil?
    onoe "Formula not installed: #{formula}"
    next
  end

  source = HOMEBREW_CELLAR + formula + version
  filename = "#{formula}-#{version}-bottle.tar.gz"
  destination = Pathname.pwd

  tab = Tab.for_keg source
  if not tab.built_bottle
    onoe "Formula not installed with '--build-bottle': #{formula}"
    next
  end

  HOMEBREW_CELLAR.cd do
    ohai "Bottling #{formula} #{version}..."
    # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
    # or an uncompressed tarball (and more bandwidth friendly).
    safe_system 'tar', 'czf', destination/filename, "#{formula}/#{version}"
    puts "./#{filename}"
    puts "bottle do"
    puts "  url 'https://downloads.sf.net/project/machomebrew/Bottles/#{filename}'"
    puts "  sha1 '#{(destination/filename).sha1}'"
    puts "end"
  end
end
