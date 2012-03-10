require 'formula'

class Hostdb < Formula
  url 'http://hostdb.googlecode.com/files/hostdb-1.004.tgz'
  homepage 'http://code.google.com/p/hostdb/'
  md5 'dfe0bf011f6e2117011aaae3ee2246b2'

  def install
    bin.install Dir['bin/*']
    doc.install Dir['docs/*']
    (share+'examples'+name).install Dir['examples/*']
  end
end
