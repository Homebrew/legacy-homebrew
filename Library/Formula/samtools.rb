require 'formula'

class Samtools < Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.18/samtools-0.1.18.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  sha1 '77be35df7a90c288a003ff826ba99aef53b2fbe6'
  head 'https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/samtools'

  def install
    system "make"
    system "make razip"
    cd 'bcftools' do
      system "make"
    end

    bin.install %w{samtools razip bcftools/bcftools bcftools/vcfutils.pl}
    bin.install %w{misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/seqtk misc/wgsim}
    bin.install Dir['misc/*.pl']
    lib.install 'libbam.a'
    man1.install %w{samtools.1}
    (share+'samtools').install %w{examples}
    (include+'bam').install Dir['*.h']
  end
end
