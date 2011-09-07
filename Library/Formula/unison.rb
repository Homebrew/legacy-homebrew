require 'formula'

class Unison < Formula
  url 'http://www.seas.upenn.edu/~bcpierce/unison//download/releases/unison-2.40.61/unison-2.40.61.tar.gz'
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  md5 '9d48796b115704321c6a4a50dd0928ee'

  depends_on 'objective-caml'

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end
