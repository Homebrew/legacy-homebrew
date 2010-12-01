# Builds binary brew package
brew_install

destination = HOMEBREW_PREFIX + "Bottles"
if not File.directory?(destination)
  Dir.mkdir destination
end

ARGV.each do|formula|
  # Get the latest version
  version = `brew list --versions #{formula}`.split.last
  source = HOMEBREW_CELLAR + formula + version
  filename = formula + '-' + version + '.tar.gz'
  ohai "Bottling #{formula} #{version}..."
  HOMEBREW_CELLAR.cd do
    # Use gzip, much faster than bzip2 and hardly any file size difference
    # when compressing binaries.
    safe_system "tar czf #{destination}/#{filename} #{formula}/#{version}"
  end
  ohai "Bottled #{filename}"
end