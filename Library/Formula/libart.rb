require 'formula'

class Libart < Formula
  homepage 'http://freshmeat.net/projects/libart/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/libart_lgpl-2.3.20.tar.bz2'
  sha1 '40aa6c6c5fb27a8a45cd7aaa302a835ff374d13a'

  bottle do
    cellar :any
    revision 1
    sha1 "aac404192ca03b3d0ae86f0a099d8c513e741d3c" => :yosemite
    sha1 "f366dbf500cb5d0ce96f76447cce108b3db95468" => :mavericks
    sha1 "1bb45d0e252483791006c138a83b133e84676f2a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
