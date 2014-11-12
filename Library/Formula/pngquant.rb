require "formula"

class Pngquant < Formula
  homepage "http://pngquant.org/"
  url "https://github.com/pornel/pngquant/archive/2.3.1.tar.gz"
  sha1 "964987f24012b247be666903ab4e31f53d84d80c"

  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha1 "4c4b52ecd2d0c6e02e6086717277eca258e96239" => :yosemite
    sha1 "73d1b4d1addd90e6c00497ff9403f97b0f6bc855" => :mavericks
    sha1 "5a8b9d3200c479ed3cf7ee0af43dc127c848eacc" => :mountain_lion
  end

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
