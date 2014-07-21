require "formula"

class Check < Formula
  homepage "http://check.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/check/check/0.9.13/check-0.9.13.tar.gz"
  sha1 "09f682d2239b1353818b74d06099a17460450240"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
