require 'formula'

class Samtools < Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.17/samtools-0.1.17.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 '9549f7a6bba894766df9c3dd18d61f0b'
  head 'https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/samtools'

  def install
    system "make"
    system "make razip"
    system "cd bcftools; make"

    bin.install %w{samtools razip bcftools/bcftools}
    (share+'samtools').install %w{examples misc}
    (share+'samtools/misc').install %w{bcftools/vcfutils.pl}
    lib.install 'libbam.a'
    (include+'bam').install Dir['*.h']
    man1.install %w{samtools.1}
  end
end
