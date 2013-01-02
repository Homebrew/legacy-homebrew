require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.8.0.tar.gz'
  sha1 'af79e0105099dd7d1223f45eb685475223043e21'

  depends_on 'snappy' => :build

  def install
    system "make"
    include.install "include/leveldb"
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.8' => 'libleveldb.1.8.dylib'
    lib.install_symlink lib/'libleveldb.1.8.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.8.dylib' => 'libleveldb.1.dylib'
  end
end
