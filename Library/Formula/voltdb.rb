class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  head "https://github.com/VoltDB/voltdb.git"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-5.6.tar.gz"
  sha256 "9ea24d8cacdf2e19ba60487f3e9dfefa83c18cb3987571abc44b858ce0db7c3e"

  depends_on :ant => :build

  def install
    system "ant"

    inreplace Dir["bin/*"] - ["bin/voltadmin","bin/voltdb","bin/rabbitmqloader"],
      /VOLTDB_LIB=\$VOLTDB_HOME\/lib/, "VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb"

    (lib/"voltdb").install Dir["lib/*"]
    lib.install_symlink lib/"voltdb/python"
    prefix.install "bin", "tools", "voltdb", "version.txt", "doc"
  end
end
