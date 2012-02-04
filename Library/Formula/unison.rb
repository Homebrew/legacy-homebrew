require 'formula'

class Unison < Formula
  url 'http://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.40.63/unison-2.40.63.tar.gz'
  homepage 'http://www.cis.upenn.edu/~bcpierce/unison/'
  md5 '3281207850cf6f0a17fe73f371893bd3'

  depends_on 'objective-caml'

  def patches
    # this is used to fix the 64-bit build bug as described in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=585453
    {:p1 => 'http://git.debian.org/?p=pkg-ocaml-maint/packages/unison.git;a=blob_plain;f=debian/patches/debbug585453_mymap.dpatch;hb=5ae435235d324efe54057a29cda5753609a8ad3c'}
  end

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install 'unison'
  end
end
