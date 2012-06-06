require 'formula'

class Libidn < Formula
  homepage 'http://www.gnu.org/software/libidn/'
  url 'http://ftpmirror.gnu.org/libidn/libidn-1.25.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libidn/libidn-1.25.tar.gz'
  sha256 '7fe625328a6a5d837d723c462c1788affb84d9c9fc0ae5cd0ce9ac7724c34716'

  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make install"
  end

  def test
    system "#{bin}/idn", "--version"
  end
end
