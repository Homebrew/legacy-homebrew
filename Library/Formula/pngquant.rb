class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.5.0-src.tar.bz2"
  sha256 "83c941f9fc7d4d6a566ca1243bff38fc9c46e4c74b6dc352fb5eac68b2297839"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "44f37e5dc9360228fcbad23e6635ba7a38d5140e9e34a52875d3cf5f2a846d89" => :yosemite
    sha256 "423891a9d736c7b7bcaaecd4e6ad74eb5d4bdc77b0d759793635f4318c7502c3" => :mavericks
    sha256 "5e7a35bc9a97c2af46366824bf60f88f62e2224074c8c6211f6e6130c3272838" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug
    system "make", "install",
           "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    File.exist? testpath/"out.png"
  end
end
