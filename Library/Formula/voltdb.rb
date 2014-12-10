require 'formula'

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.7.tar.gz'
  sha1 'f6a8cf8652b7247ea39bfa2f6fa410a15ffc6ab5'

  depends_on :ant => :build

  def install
    system 'ant'

    inreplace Dir["bin/*"] - ["bin/voltadmin"],
      /VOLTDB_LIB=\$VOLTDB_HOME\/lib/, 'VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb'

    (lib/'voltdb').install Dir['lib/*']
    lib.install_symlink lib/"voltdb/python"
    prefix.install 'bin', 'tools', 'voltdb', 'version.txt', 'doc'
  end
end
