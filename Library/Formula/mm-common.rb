class MmCommon < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.9.tar.xz"
  sha256 "9d00bc77e77794e0bd2ae68132c4b4136aa115d255e34b310f7449b29db50b7a"

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
