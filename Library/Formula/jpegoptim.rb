require "formula"

class Jpegoptim < Formula
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.0.tar.gz"
  sha1 "54c9cb32d1927d88b3ba4533dd965450f986aaec"
  head "https://github.com/tjko/jpegoptim.git"

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
