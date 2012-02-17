require 'formula'

class Darkice < Formula
  homepage 'http://code.google.com/p/darkice/'
  url 'http://darkice.googlecode.com/files/darkice-1.1.tar.gz'
  sha1 '8379670b477ce72beabd3a2d920ee880f69d7a30'

  head 'http://darkice.googlecode.com/svn/darkice/branches/darkice-macosx'

  depends_on 'libvorbis'
  depends_on 'lame'
  depends_on 'two-lame'
  depends_on 'faac'
  depends_on 'jack'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lame-prefix=#{HOMEBREW_PREFIX}",
                          "--with-vorbis-prefix=#{HOMEBREW_PREFIX}",
                          "--with-twolame-prefix=#{HOMEBREW_PREFIX}",
                          "--with-faac-prefix=#{HOMEBREW_PREFIX}",
                          "--with-jack-prefix=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
