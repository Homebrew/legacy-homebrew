require 'formula'

class Samtools <Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.13/samtools-0.1.13.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 '2e66b94639f90d10cc935bb145ef71f3'

  def install
    system "make"
    system "make razip"

    bin.install %w{samtools razip}
    prefix.install %w{examples misc}
    lib.install 'libbam.a'
    (include+'bam').install Dir['*.h']
  end
end
