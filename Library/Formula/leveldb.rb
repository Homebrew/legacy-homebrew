require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.15.0.tar.gz'
  sha1 '74b70a1156d91807d8d84bfdd026e0bb5acbbf23'

  bottle do
    cellar :any
    revision 1
    sha1 '8dd490f735718185eed16bd631f2932c82738eed' => :mavericks
    sha1 '509c59997b6c5b678a4ca18d87d0d28d82b86684' => :mountain_lion
    sha1 'b122afaf1eb83eeb8b637b80b8792b5f6b92496f' => :lion
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
