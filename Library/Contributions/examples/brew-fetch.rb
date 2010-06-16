# Downloads the tarballs for the given formulae to the Cache

require 'formula'

ARGV.formulae.each do |f|
  f.downloader.fetch
end
