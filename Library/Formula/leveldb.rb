require "formula"

class Leveldb < Formula
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.18.tar.gz"
  sha1 "18684a0ad7a07920d10f5295b171fbf5eeec7337"

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
