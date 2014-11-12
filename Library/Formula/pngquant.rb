require "formula"

class Pngquant < Formula
  homepage "http://pngquant.org/"
  url "https://github.com/pornel/pngquant/archive/2.3.1.tar.gz"
  sha1 "964987f24012b247be666903ab4e31f53d84d80c"

  head "https://github.com/pornel/pngquant.git"

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug
    system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    bin.install "pngquant"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", "--help"
  end
end
