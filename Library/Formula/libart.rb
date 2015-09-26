class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "http://freshmeat.net/projects/libart/"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.20.tar.bz2"
  sha256 "d5531ae3a206a9b5cc74e9a20d89d61b2ba3ba03d342d6a2ed48d2130ad3d847"

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
    system "make", "install"
  end
end
