require 'formula'

class Cmucl < Formula
  homepage 'http://www.cons.org/cmucl'
  url 'http://common-lisp.net/project/cmucl/downloads/release/20d/cmucl-20d-x86-darwin.tar.bz2'
  sha1 '5d22ea9850abb8af9adf221d78ed20890b502c4a'

  skip_clean 'bin'

  def install
    bin.install 'bin/lisp'
    lib.install 'lib/cmucl'

    doc.install Dir['doc/cmucl/*']
    man1.install Dir['man/man1/*']
  end
end
