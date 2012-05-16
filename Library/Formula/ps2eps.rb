require 'formula'

class Ps2eps < Formula
  homepage 'http://www.tm.uka.de/~bless/ps2eps'
  url 'http://www.tm.uka.de/~bless/ps2eps-1.68.tar.gz'
  md5 'd6d2932b9d0399317a7382c94c108c44'

  depends_on 'ghostscript'

  def install
    inreplace 'bin/ps2eps', /^eval.*$/, '#!/usr/bin/perl'
    bin.mkpath
    bin.install 'bin/ps2eps'
    share.mkpath
    share.install Dir['doc/man']
    doc.mkpath
    doc.install Dir['doc/pdf']
    doc.install Dir['doc/html']
    system "#{ENV.cc} -O2 src/C/bbox.c -obbox"
    bin.install 'bbox'
  end
end
