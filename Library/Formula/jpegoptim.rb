require "formula"

class Jpegoptim < Formula
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.1.tar.gz"
  sha1 "07561b8a06806c4a2172a62e3f5e45b961353b2d"
  head "https://github.com/tjko/jpegoptim.git"

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end
