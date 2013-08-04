require 'formula'

class Formula
  def tools; prefix+'tools' end
  def voltdb; prefix+'voltdb' end
end

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git', :using => :git
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.4.tar.gz'
  sha1 '9a45ee70b99ea32c0c919b786ba528677db3d28'

  depends_on 'ant'
  depends_on :python
  depends_on 'valgrind' => :optional

  env :userpaths

  def install
    system 'ant'
    bin.install Dir['bin/*']
    lib.install Dir['lib/*']
    tools.install Dir['tools/*']
    voltdb.install Dir['voltdb/*']
    doc.install Dir['doc/*']
    prefix.install 'version.txt'
  end

  test do
    system 'false'
  end
end
