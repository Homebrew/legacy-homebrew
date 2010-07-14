require 'formula'

class Cmucl <Formula
  url 'http://common-lisp.net/project/cmucl/downloads/release/20a/cmucl-20a-x86-darwin.tar.bz2'
  version '20a'
  homepage 'http://www.cons.org/cmucl'
  md5 '15712845405e0052e72af7cac0a5f3ae'

  skip_clean 'bin'

  def install
    bin.install 'bin/lisp'
    lib.install 'lib/cmucl'

    doc.install Dir['doc/cmucl/*']
    man1.install Dir['man/man1/*']
  end
end
