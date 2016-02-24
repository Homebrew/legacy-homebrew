class Voltdb < Formula
  desc "Horizontally-scalable, in-memory SQL RDBMS"
  homepage "https://github.com/VoltDB/voltdb"
  head "https://github.com/VoltDB/voltdb.git"
  url "https://github.com/VoltDB/voltdb/archive/voltdb-5.6.tar.gz"
  sha256 "9ea24d8cacdf2e19ba60487f3e9dfefa83c18cb3987571abc44b858ce0db7c3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "abc39a5926dc83b8516c8697beeef5d722049bf487d28db60f4a095cc5299329" => :el_capitan
    sha256 "300a47847d49c7e2d2dfb37c860cd4e60b1074d43dab450433a8c49879c9c46b" => :yosemite
    sha256 "de7b5adf80d177bde762b71d1044a901b2b68b0b22ec328f73137b99fc885248" => :mavericks
  end

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
