require 'formula'

class Unison < Formula
  url 'http://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.40.63/unison-2.40.63.tar.gz'
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  md5 '3281207850cf6f0a17fe73f371893bd3'

  depends_on 'objective-caml'

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end
