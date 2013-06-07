require 'formula'

class OCLint < Formula
  homepage 'http://oclint.org'
  url 'http://archives.oclint.org/releases/0.6/oclint-0.6-x86_64-apple-darwin12.tar.gz'
  version '0.6'
  sha1 '9fb4bdfb6dbce14986d863d8b672870c0ae08ec8'

  depends_on 'llvm'

  def install
      lib.install Dir['lib/oclint']
      bin.install Dir['bin/*']
    end

    def test
      system "oclint -h"
    end
end
