require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.5.0.tar.gz'
  sha1 'b5b45ff74065f242c37f465b13dafb925972ca43'

  depends_on 'snappy' => :build

  def install
    system "make"
    include.install "include/leveldb"
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.5' => 'libleveldb.1.5.dylib'
    lib.install_symlink lib/'libleveldb.1.5.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.5.dylib' => 'libleveldb.1.dylib'
  end
end
