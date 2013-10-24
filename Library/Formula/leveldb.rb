require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.12.0.tar.gz'
  sha1 'e7b84f239949920bfc2d7d1074ec6a6fa8869e23'

  depends_on 'snappy' => :build

  def install
    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.12' => 'libleveldb.1.12.dylib'
    lib.install_symlink lib/'libleveldb.1.12.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.12.dylib' => 'libleveldb.1.dylib'
  end
end
