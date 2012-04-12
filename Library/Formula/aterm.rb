require 'formula'

class Aterm < Formula
  homepage 'http://strategoxt.org/Tools/ATermFormat'
  url 'ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.17/aterm-2.5.tar.gz'
  md5 '33ddcb1a229baf406ad1f603eb1d5995'

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.j1 # Parallel builds don't work
    system "make install"
  end
end
