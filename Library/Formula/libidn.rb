require 'formula'

class Libidn < Formula
  url 'http://ftp.gnu.org/gnu/libidn/libidn-1.19.tar.gz'
  homepage 'http://www.gnu.org/software/libidn/'
  sha1 '2b6dcb500e8135a9444a250d7df76f545915f25f'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make install"
  end
end
