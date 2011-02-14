require 'formula'

class Pianobar <Formula
  url 'https://github.com/PromyLOPh/pianobar/tarball/2011.01.24'
  version '2011.01.24'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 '97ee5b39e5e9006f6139db2787f346a0'

  head 'git://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  skip_clean :bin

  def install
    ENV.delete "CFLAGS"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
