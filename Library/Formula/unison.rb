require 'formula'

class Unison < Formula
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.32.52.tar.gz'
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  md5 '0701f095c1721776a0454b94607eda48'

  depends_on 'objective-caml'

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end
