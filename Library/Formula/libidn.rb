require "formula"

class Libidn < Formula
  homepage "http://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.29.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn-1.29.tar.gz"
  sha256 "fb82747dbbf9b36f703ed27293317d818d7e851d4f5773dedf3efa4db32a7c7c"

  bottle do
    cellar :any
    sha1 "23cb37001f1fb723b86b11717fb4df76f58934ff" => :mavericks
    sha1 "0ee166fdc8fd9a0ad245efd89323868209968235" => :mountain_lion
    sha1 "866251da871fe76c180f5b7247d4458175778313" => :lion
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
