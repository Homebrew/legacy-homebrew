require "formula"

class Libxmlxx < Formula
  homepage "http://libxmlplusplus.sourceforge.net"
  url "http://ftp.gnome.org/pub/GNOME/sources/libxml++/2.36/libxml++-2.36.0.tar.xz"
  sha256 "bfdf327bf9ebd12946b7aa6a152045f209d5c9fecd06ebfcdf9b3e7c1af6e2e1"

  bottle do
    sha1 "3a2d850b88b4552b0466250211ea40b5b3816a64" => :mavericks
    sha1 "ca11491cc3bee2d51184b57bebae0479616eaf4b" => :mountain_lion
    sha1 "6fe9b9176b1ad77c409d3098eaa9ef4fbefef6b6" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  # LibXML++ can't compile agains the version of LibXML shipped with Leopard
  depends_on "libxml2" if MacOS.version <= :leopard

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
