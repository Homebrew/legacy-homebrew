require "formula"

class Glibmm < Formula
  homepage "http://www.gtkmm.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.42/glibmm-2.42.0.tar.xz"
  sha256 "985083d97378d234da27a7243587cc0d186897a4b2d3c1286f794089be1a3397"

  bottle do
    sha1 "dfd9e07af7ab9d12f4da8fdfa2022c98681c0868" => :mavericks
    sha1 "8b1708d725d18c132d3096d5c967999d20840cf1" => :mountain_lion
    sha1 "4bfe515499a03792b9807ac4ea953ed552131bb7" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
