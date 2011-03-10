require 'formula'

class Darkice < Formula
  # coreaudio brach of darkice
  head 'http://darkice.googlecode.com/svn/darkice/branches/darkice-macosx'
  homepage 'http://darkice.org/'

  depends_on 'libvorbis'
  depends_on 'lame'
  depends_on 'two-lame'
  depends_on 'faac'
  depends_on 'jack'

  def install
    inreplace 'autogen.sh', 'libtool', 'glibtool'
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--with-lame-prefix=#{HOMEBREW_PREFIX}",
                           "--with-vorbis-prefix=#{HOMEBREW_PREFIX}",
                           "--with-twolame-prefix=#{HOMEBREW_PREFIX}",
                           "--with-faac-prefix=#{HOMEBREW_PREFIX}",
                           "--with-jack-prefix=#{HOMEBREW_PREFIX}",
                           "--with-core=yes"
    system "make install"
  end
end
