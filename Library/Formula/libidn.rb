require 'formula'

class Libidn < Formula
  homepage 'http://www.gnu.org/software/libidn/'
  url 'http://ftpmirror.gnu.org/libidn/libidn-1.26.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libidn/libidn-1.26.tar.gz'
  sha256 '0a2f4c71c80f8f389a99d5a26539a9be4a4ac42cd7f375aa41046660f63cc53c'

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
