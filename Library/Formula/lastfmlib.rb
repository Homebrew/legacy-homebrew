require 'formula'

class Lastfmlib < Formula
  url 'http://lastfmlib.googlecode.com/files/lastfmlib-0.4.0.tar.gz'
  homepage 'http://code.google.com/p/lastfmlib/'
  md5 'f6f00882c15b8cc703718d22e1b1871f'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
