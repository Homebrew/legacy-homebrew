require 'formula'

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.4.tar.gz'
  sha1 '9a45ee70b99ea32c0c919b786ba528677db3d284'

  def install
    system 'ant'

    inreplace 'bin/voltdb', /VOLTDB_LIB=\$VOLTDB_HOME\/lib/, 'VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb'

    Dir['lib/*'].each do |f| (lib/'voltdb').install f end
    ln_s lib/'voltdb/python', lib/'python'
    prefix.install 'bin', 'tools', 'voltdb', 'version.txt', 'doc'
  end

  test do
    assert_equal "3.4\n", File.read("#{prefix}/version.txt")
  end
end
