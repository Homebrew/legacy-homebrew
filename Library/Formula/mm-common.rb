class MmCommon < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.8.tar.xz"
  sha256 "c9ab5fd3872fbe245fbc35347acf4a95063111f81d54c43df3af662dad0a03d5"

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
