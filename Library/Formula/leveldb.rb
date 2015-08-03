class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.18.tar.gz"
  sha256 "4aa1a7479bc567b95a59ac6fb79eba49f61884d6fd400f20b7af147d54c5cee5"

  bottle do
    cellar :any
    sha1 "80a3d4ffe14368c5f81333f50f3c60c5a030a78c" => :yosemite
    sha1 "2f66934542880fc0be0a0e5c5448797e4d0b7182" => :mavericks
    sha1 "0658b662127010a2651a9ff7b8fe1361521b6094" => :mountain_lion
  end

  depends_on "snappy"

  def install
    system "make"
    system "make", "leveldbutil"

    include.install "include/leveldb"
    bin.install "leveldbutil"
    lib.install "libleveldb.a"
    lib.install "libleveldb.dylib.1.18" => "libleveldb.1.18.dylib"
    lib.install_symlink lib/"libleveldb.1.18.dylib" => "libleveldb.dylib"
    lib.install_symlink lib/"libleveldb.1.18.dylib" => "libleveldb.1.dylib"
    system "install_name_tool", "-id", "#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.18.dylib"
  end
end
