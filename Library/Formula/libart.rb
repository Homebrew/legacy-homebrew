class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "http://freshmeat.net/projects/libart/"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.20.tar.bz2"
  sha256 "d5531ae3a206a9b5cc74e9a20d89d61b2ba3ba03d342d6a2ed48d2130ad3d847"

  bottle do
    cellar :any
    revision 1
    sha256 "8244ab052847fae8d71599115dad7cfb2a0bb1820c61fef30b7ee7c23d0c7e37" => :yosemite
    sha256 "ff0263c2dfa94de8196b3a46cce14e4c877286916d0ef6d06ac8b5ff4abc272e" => :mavericks
    sha256 "3a84be9bec8759d406dfd1919325d8e415b1632217b77b6dc7052db76fda3986" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
