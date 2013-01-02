require 'formula'

class Orbit < Formula
  homepage 'http://projects.gnome.org/ORBit2/'
  url 'http://ftp.gnome.org/pub/gnome/sources/ORBit2/2.14/ORBit2-2.14.19.tar.bz2'
  sha256 '55c900a905482992730f575f3eef34d50bda717c197c97c08fa5a6eafd857550'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libidl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
