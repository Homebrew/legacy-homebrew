require 'formula'

class Formula
  def tools; prefix+'tools' end
  def voltdb; prefix+'voltdb' end
end

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.4.tar.gz'
  sha1 '9a45ee70b99ea32c0c919b786ba528677db3d284'

  depends_on :python

  def install
    system 'ant'

    bin.install Dir['bin/*']
    Dir['lib/*'].each do |f|
      (lib/'voltdb').install f
    end
    ln_s lib/'voltdb/python', lib/'python'
    ln_s lib/'voltdb/extension', lib/'extension'
    tools.install Dir['tools/*']
    voltdb.install Dir['voltdb/*']
    doc.install Dir['doc/*']
    prefix.install 'version.txt'

    file_to_mod = prefix/'bin/voltdb'
    system("chmod +w #{file_to_mod}")
    system("sed -i '' 's/VOLTDB_LIB=\$VOLTDB_HOME\\/lib/VOLTDB_LIB=\$VOLTDB_HOME\\/lib\\/voltdb/' #{file_to_mod}")
    system("chmod -w #{file_to_mod}")
  end

  test do
    f = File.read("#{prefix}/version.txt")
    f == "3.4\n" ? true : false
  end
end
