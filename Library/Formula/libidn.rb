require "formula"

class Libidn < Formula
  homepage "http://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.29.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn-1.29.tar.gz"
  sha256 "fb82747dbbf9b36f703ed27293317d818d7e851d4f5773dedf3efa4db32a7c7c"

  bottle do
    cellar :any
    sha1 "a44c5f19b4814f6c32ecb9d13f7043095348df2c" => :mavericks
    sha1 "aec417a8c628313757dad09ff19a2ce3708a2d96" => :mountain_lion
    sha1 "74eabd145413365737b9cae31235a9c6e90f24e5" => :lion
  end

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make install"
  end

  test do
    system "#{bin}/idn", "--version"
  end
end
