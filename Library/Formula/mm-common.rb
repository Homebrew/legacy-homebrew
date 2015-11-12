class MmCommon < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.8.tar.xz"
  sha256 "c9ab5fd3872fbe245fbc35347acf4a95063111f81d54c43df3af662dad0a03d5"

  bottle do
    sha256 "b6366001d4cd06cd25556862bfaeca62db80cf07d55e8fcda8d8978e7bc85125" => :yosemite
    sha256 "ae6f4e4449d54b47d556e0831a861b9d5d3db9ad06e99d50f87e2f41035c80a7" => :mavericks
    sha256 "57104e0bf06f9420bc0b38f6295ddc3e0f4aa90cfef08e830a1169f2c4343841" => :mountain_lion
  end

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
