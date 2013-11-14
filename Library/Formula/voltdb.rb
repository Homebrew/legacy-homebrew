require 'formula'

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.7.tar.gz'
  sha1 'f6a8cf8652b7247ea39bfa2f6fa410a15ffc6ab5'

  depends_on :ant

  def install
    system 'ant'

    Dir['bin/*'].each do |f|
      next if ['bin/voltadmin'].include? f
      inreplace f, /VOLTDB_LIB=\$VOLTDB_HOME\/lib/, 'VOLTDB_LIB=$VOLTDB_HOME/lib/voltdb'
    end

    (lib/'voltdb').install Dir['lib/*']
    ln_s lib/'voltdb/python', lib/'python'
    prefix.install 'bin', 'tools', 'voltdb', 'version.txt', 'doc'
  end
end
