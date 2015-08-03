class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  head "https://github.com/VoltDB/voltdb.git"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-3.7.tar.gz"
  sha256 "c66d838551e7f4689ec0e4314723951a6450d994079d8564b3af16c193036d30"

  depends_on :ant => :build

  def install
    system "ant"

    inreplace Dir["bin/*"] - ["bin/voltadmin"],
      /VOLTDB_LIB=\$VOLTDB_HOME\/lib/, "VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb"

    (lib/"voltdb").install Dir["lib/*"]
    lib.install_symlink lib/"voltdb/python"
    prefix.install "bin", "tools", "voltdb", "version.txt", "doc"
  end
end
