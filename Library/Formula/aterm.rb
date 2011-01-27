require 'formula'

class Aterm <Formula
  url 'ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.17/aterm-2.5.tar.gz'
  homepage 'http://strategoxt.org/Tools/ATermFormat'
  md5 '33ddcb1a229baf406ad1f603eb1d5995'

  def install
    system "./configure", "--prefix=#{prefix}"
    # The build fails mysteriously with -j4
    ENV.j1
    system "make install"
  end
end
