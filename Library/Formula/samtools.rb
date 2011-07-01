require 'formula'

class Samtools < Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.16/samtools-0.1.16.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 'ae26c63a783f95a45ddf8a109c9d9a5d'
  head 'https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/samtools'

  def install
    system "make"
    system "make razip"

    bin.install %w{samtools razip}
    (share+'samtools').install %w{examples misc}
    lib.install 'libbam.a'
    (include+'bam').install Dir['*.h']
    man1.install 'samtools.1'
  end
end
