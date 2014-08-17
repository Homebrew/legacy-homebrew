require 'formula'

class Darkice < Formula
  homepage 'http://code.google.com/p/darkice/'
  url 'https://darkice.googlecode.com/files/darkice-1.2.tar.gz'
  sha1 '508eb0560a7cdf0990a8793f4b8d324ae74bc343'

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
