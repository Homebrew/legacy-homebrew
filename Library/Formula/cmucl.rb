require 'formula'

class Cmucl <Formula
  url 'http://common-lisp.net/project/cmucl/downloads/release/20b/cmucl-20b-x86-darwin.tar.bz2'
  version '20b'
  homepage 'http://www.cons.org/cmucl'
  md5 'd1128868be1098eb48caf04de9dacca4'

  skip_clean 'bin'

  def install
    bin.install 'bin/lisp'
    lib.install 'lib/cmucl'

    doc.install Dir['doc/cmucl/*']
    man1.install Dir['man/man1/*']
  end
end
