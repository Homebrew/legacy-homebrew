require 'formula'

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.5.0.1.tar.gz'
  sha1 'ce4d890967c6f3f8772dd66e65d5a3aeb85cd5f3'

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

  test do
    assert_equal "3.5.0.1\n", File.read("#{prefix}/version.txt")
  end
end
