require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.15.0.tar.gz'
  sha1 '74b70a1156d91807d8d84bfdd026e0bb5acbbf23'

  bottle do
    cellar :any
    sha1 'dd654d1abd93861c7d9573cb1171b59c8e23f50e' => :mavericks
    sha1 'bd6bfb0889d0f563d760aa149536878493da5467' => :mountain_lion
    sha1 'b30b1116005497f772b8af926e7c423f79174aab' => :lion
  end

  depends_on 'snappy'

  def install
    system 'make'
    system 'make', 'leveldbutil'

    include.install 'include/leveldb'
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.15' => 'libleveldb.1.15.dylib'
    lib.install_symlink lib/'libleveldb.1.15.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.15.dylib' => 'libleveldb.1.dylib'
  end
end
