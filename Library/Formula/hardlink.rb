require "formula"

class Hardlink < Formula
  homepage "http://jak-linux.org/projects/hardlink/"
  url "http://jak-linux.org/projects/hardlink/hardlink_0.2.0.tar.gz"
  sha1 "6ba0fe26bbdf4feac6483550f647b4424e614cb9"

  devel do
    url "http://jak-linux.org/projects/hardlink/hardlink_0.3.0~rc2.tar.gz"
    version "0.3.0_rc2"
    sha1 "0a55a96a79839f668ca392cc0a11fa521044807d"
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-getopt"
  depends_on "pcre"

  def install
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "BINDIR=#{bin}", "install"
  end

  test do
    system "#{bin}/hardlink", "--help"
  end
end
