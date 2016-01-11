class Tpl < Formula
  desc "Store and retrieve binary data in C"
  homepage "https://troydhanson.github.io/tpl/"
  url "https://github.com/troydhanson/tpl/archive/v1.6.1.tar.gz"
  sha256 "0b3750bf62f56be4c42f83c89d8449b24f1c5f1605a104801d70f2f3c06fb2ff"
  head "https://github.com/troydhanson/tpl.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tests"
  end
end
