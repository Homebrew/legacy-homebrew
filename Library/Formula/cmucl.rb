require 'formula'

class Cmucl < Formula
  homepage 'http://www.cons.org/cmucl'
  url 'http://common-lisp.net/project/cmucl/downloads/release/20c/cmucl-20c-x86-darwin.tar.bz2'
  md5 '98dc8fe17a7033fdd39fab35a2147ea9'

  skip_clean 'bin'

  def install
    bin.install 'bin/lisp'
    lib.install 'lib/cmucl'

    doc.install Dir['doc/cmucl/*']
    man1.install Dir['man/man1/*']
  end
end
