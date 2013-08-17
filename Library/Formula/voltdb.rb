require 'formula'

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.5.tar.gz'
  sha1 'fb765f087e2faf95b8187182a88d4058f8bfa5e2'

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
    assert_equal "3.5\n", File.read("#{prefix}/version.txt")
  end
end

