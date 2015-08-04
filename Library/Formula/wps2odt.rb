class Wps2odt < Formula
  desc "Library for importing MS Works word processor file format"
  homepage "http://libwps.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libwps/wps2odt/wps2odt-0.2.0/wps2odt-0.2.0.tar.bz2"
  sha256 "2db22d4f84b2e2198a427fb967b993e4356db09c0a18cfb3aef1aa5a7eb77459"

  depends_on "pkg-config" => :build
  depends_on "libwps"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
