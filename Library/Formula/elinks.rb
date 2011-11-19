require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  md5 'fcd087a6d2415cd4c6fd1db53dceb646'

  head 'http://elinks.cz/elinks.git', :using => :git

  fails_with_llvm :build => 2326

  def install
    ENV.deparallelize
    ENV.delete('LD')
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey"
    system "make install"
  end
end
