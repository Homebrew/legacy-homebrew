require 'formula'

class Libidn < Formula
  homepage 'http://www.gnu.org/software/libidn/'
  url 'http://ftpmirror.gnu.org/libidn/libidn-1.23.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libidn/libidn-1.23.tar.gz'
  sha256 '25b42d75851ebae52e1c969353b74eefd3d6817f41c8d2a6db258f5ec60c5e6a'

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
