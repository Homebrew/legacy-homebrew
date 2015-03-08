# encoding: UTF-8
class Libidn < Formula
  homepage "https://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.30.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.30.tar.gz"
  sha256 "39b9fc94d74081c185757b12e0891ce5a22db55268e7d1bb24533ff4432eb053"

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
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system "#{bin}/idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
