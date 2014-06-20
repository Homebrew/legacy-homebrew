require 'formula'

class Hatari < Formula
  homepage 'http://hatari.tuxfamily.org'
  url 'http://download.tuxfamily.org/hatari/1.7.0/hatari-1.7.0.tar.bz2'
  sha1 '9961171c6d5f3742f93c903606c4956ce2e15ea0'
  revision 1

  head 'http://hg.tuxfamily.org/mercurialroot/hatari/hatari', :using => :hg, :branch => 'default'

  depends_on 'cmake' => :build
  depends_on 'libpng'
  depends_on 'sdl'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-osx-bundle"
    system "make install"
  end
end
