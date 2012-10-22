require 'formula'

class Ps2eps < Formula
  homepage 'http://www.tm.uka.de/~bless/ps2eps'
  url 'http://www.tm.uka.de/~bless/ps2eps-1.68.tar.gz'
  sha1 '253b949b70e73beb68760aafc5a20357db17371a'

  depends_on 'ghostscript'

  skip_clean 'bin' # Don't strip +x on ps2eps

  def install
    system "#{ENV.cc} #{ENV.cflags} src/C/bbox.c -obbox"
    bin.install 'bin/ps2eps'
    bin.install 'bbox'
    share.install Dir['doc/man']
    doc.install Dir['doc/pdf']
    doc.install Dir['doc/html']
  end
end
