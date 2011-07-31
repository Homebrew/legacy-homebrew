require 'formula'

class Leveldb < Formula
  homepage 'http://code.google.com/p/leveldb/'
  head 'http://leveldb.googlecode.com/svn/trunk/'

  depends_on 'snappy'

  def install
    system 'make'
    lib.install 'libleveldb.a'
    include.install 'include/leveldb'
    doc.install Dir['doc/*']
  end
end
