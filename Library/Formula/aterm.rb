require 'formula'

class Aterm < Formula
  homepage 'http://strategoxt.org/Tools/ATermFormat'
  url 'ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.17/aterm-2.5.tar.gz'
  sha1 'a7b1a7b480c1d06df73dc5763c011284ddde5ae3'

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.j1 # Parallel builds don't work
    system "make install"
  end
end
