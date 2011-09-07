require 'formula'

class Tabix < Formula
  url 'http://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.5.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 '1fb65a3f79a81681ad6d5012498d2d51'
  head 'https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/tabix'

  def install
    system "make"
    bin.install %w{tabix bgzip}
    man1.install 'tabix.1'
    ln_s man1+'tabix.1', man1+'bgzip.1'
  end
end
