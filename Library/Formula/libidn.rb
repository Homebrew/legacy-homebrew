require 'formula'

class Libidn < Formula
  homepage 'http://www.gnu.org/software/libidn/'
  url 'http://ftpmirror.gnu.org/libidn/libidn-1.27.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libidn/libidn-1.27.tar.gz'
  sha256 '103ff719d36484ebfb57272e8155312da105caa5d3f42d51d45e1930356e95fd'

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make install"
  end

  def test
    system "#{bin}/idn", "--version"
  end
end
