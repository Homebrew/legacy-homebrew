require 'formula'

class Primer3 < Formula
  url 'http://downloads.sourceforge.net/project/primer3/primer3/2.2.3/primer3-2.2.3.tar.gz'
  homepage 'http://primer3.sourceforge.net/'
  md5 'b9cdcff68637479c094844d652c03839'

  def install
    Dir.chdir "src"
    system "make all"
    bin.install %w(primer3_core ntdpal oligotm long_seq_tm_test)
  end
end
