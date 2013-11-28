require 'formula'

class Cmucl < Formula
  homepage 'http://www.cons.org/cmucl'
  url 'http://common-lisp.net/project/cmucl/downloads/release/20e/cmucl-20e-x86-darwin.tar.bz2'
  sha1 'e346f6f049f9c5ebb825aba4b5ab5e0367452c7c'

  skip_clean 'bin'

  def install
    bin.install 'bin/lisp'
    lib.install 'lib/cmucl'

    doc.install Dir['doc/cmucl/*']
    man1.install Dir['man/man1/*']
  end
end
