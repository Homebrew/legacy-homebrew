require 'formula'

class Ps2eps < Formula
  homepage 'http://www.tm.uka.de/~bless/ps2eps'
  url 'http://www.tm.uka.de/~bless/ps2eps-1.68.tar.gz'
  md5 'd6d2932b9d0399317a7382c94c108c44'

  depends_on 'ghostscript'

  def install
    inreplace 'bin/ps2eps', /^eval.*$/, '#!/usr/bin/env perl'
    inreplace 'bin/ps2eps', /^.*if 0;/, '#'
    bin.install 'bin/ps2eps'
    share.install Dir['doc/man']
    doc.install Dir['doc/pdf']
    doc.install Dir['doc/html']
    system "#{ENV.cc} #{ENV.cflags} src/C/bbox.c -obbox"
    bin.install 'bbox'
  end
end
