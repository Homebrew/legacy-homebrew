require "formula"

class IconNamingUtils < Formula
  homepage "http://tango.freedesktop.org/"
  url "http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.gz"
  sha1 "a195e635fd663f0697a2a047f0c9134876900cf1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
