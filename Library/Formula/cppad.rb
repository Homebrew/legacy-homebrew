require 'formula'

def build_tests?; ARGV.include? '--test'; end

class Cppad < Formula
  version "20120316"
  url 'https://projects.coin-or.org/svn/CppAD/trunk',
    :using => SubversionDownloadStrategy, :revision => 2355
  homepage 'http://www.coin-or.org/CppAD'
  version 'r2355'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-stdvector"
    system "make test" if build_tests?
    system "make install"
  end

end
