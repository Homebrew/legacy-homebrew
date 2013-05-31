require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.10.0.tar.gz'
  sha1 'd5b234658138d07f6edc2de24e01d9b0585c03cb'

  depends_on 'snappy' => :build

  def install
    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.10' => 'libleveldb.1.10.dylib'
    lib.install_symlink lib/'libleveldb.1.10.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.10.dylib' => 'libleveldb.1.dylib'
  end
end
