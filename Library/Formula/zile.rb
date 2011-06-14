require 'formula'

class Zile < Formula
  url 'http://ftp.gnu.org/gnu/zile/zile-2.3.24.tar.gz'
  homepage 'http://www.gnu.org/software/zile/'
  md5 'fe77d801ba69e0fb9b4914a04b9ff506'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
