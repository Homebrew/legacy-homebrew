require 'formula'

class Darcs <Formula
  homepage 'http://darcs.net/'
  url 'http://darcs.net/binaries/macosx/darcs-2.5-OSX-10.6-i386.tar.gz'
  md5 'd9d6c05463846f9b4cf9386ea714cb16'
  version '2.5'

  depends_on 'ghc'

  def install
      system "tar zxvf darcs-2.5-OSX-10.6-i386.tar.gz"
      mkdir bin
      mv 'darcs', bin
  end
end
