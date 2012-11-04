require 'formula'

class Unison < Formula
  url 'http://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.40.63/unison-2.40.63.tar.gz'
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  sha1 '645e70bc37a5d4e8e9ccb7bad065fc579b18cf75'

  depends_on 'objective-caml'

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end
