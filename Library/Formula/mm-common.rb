require "formula"

class MmCommon < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org"
  url "http://ftp.gnome.org/pub/GNOME/sources/mm-common/0.9/mm-common-0.9.7.tar.xz"
  sha256 "78f47336f3bdf034a384c59a39cc9f0d566e69e36aa7c9ee3ec0bb6a94bf8b3e"

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
