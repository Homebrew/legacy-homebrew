require "formula"

class Uget < Formula
  homepage "http://ugetdm.com/"
  url "https://downloads.sourceforge.net/project/urlget/uget%20%28stable%29/1.10.4/uget-1.10.4.tar.gz"
  sha1 "4375bf38aa593e628351089e30d921db03e25908"

  depends_on :x11
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-notify",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
