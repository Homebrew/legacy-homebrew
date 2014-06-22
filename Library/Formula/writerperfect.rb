require "formula"

class Writerperfect < Formula
  homepage "http://libwpd.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.1/writerperfect-0.9.1.tar.bz2"
  sha1 "3a71d699dfdcd5a74639c092d62f0566ecd0dce5"

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

  test do
    system "echo", "`#{bin}/wpd2odt`"
  end
end
