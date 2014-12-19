require "formula"

class Libidn < Formula
  homepage "http://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.29.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn-1.29.tar.gz"
  sha256 "fb82747dbbf9b36f703ed27293317d818d7e851d4f5773dedf3efa4db32a7c7c"

  bottle do
    cellar :any
    revision 1
    sha1 "ee3fa3bc8ab104553777ed22dc080178bf264bd0" => :yosemite
    sha1 "9343d41b0a0ea4f1dd895eafa2f893e133f8cf76" => :mavericks
    sha1 "35fd90e1199a09fb4d5f85ad0088858279ea002f" => :mountain_lion
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
