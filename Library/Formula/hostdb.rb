require 'formula'

class Hostdb < Formula
  url 'http://hostdb.googlecode.com/files/hostdb-1.004.tgz'
  homepage 'http://code.google.com/p/hostdb/'
  sha1 '65ec59c2c88b763813fa611d8fd28a45cd9d5278'

  def install
    bin.install Dir['bin/*']
    doc.install Dir['docs/*']
    (share+'examples'+name).install Dir['examples/*']
  end
end
