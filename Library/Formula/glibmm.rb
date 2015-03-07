require "formula"

class Glibmm < Formula
  homepage "http://www.gtkmm.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.42/glibmm-2.42.0.tar.xz"
  sha256 "985083d97378d234da27a7243587cc0d186897a4b2d3c1286f794089be1a3397"

  bottle do
    revision 1
    sha1 "c4bb776154321f4a6f55533b656bbfd01fb5d0d0" => :yosemite
    sha1 "91bcad6b5c2d5f5c7feb45297888ffd05c618e1b" => :mavericks
    sha1 "2470f84fef26c7fccea181b549ddb9725dde0aba" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
