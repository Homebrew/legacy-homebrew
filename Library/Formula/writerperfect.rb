require "formula"

class Writerperfect < Formula
  homepage "http://libwpd.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.1/writerperfect-0.9.1.tar.bz2"
  sha1 "3a71d699dfdcd5a74639c092d62f0566ecd0dce5"

  bottle do
    cellar :any
    sha1 "f6787986d7acf9d615f128792842e76e5b996c34" => :mavericks
    sha1 "a75fac916f334c5edd38d8636d25460a9cd8041e" => :mountain_lion
    sha1 "9d2e62a9eb89f353f236a7e086fcd03829a12bb6" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libodfgen"
  depends_on "libwps"
  depends_on "libwpg"
  depends_on "libwpd"
  depends_on "libetonyek" => :optional
  depends_on "libvisio" => :optional
  depends_on "libmspub" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
