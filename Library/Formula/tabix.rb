require 'formula'

class Tabix < Formula
  homepage 'http://samtools.sourceforge.net/'
  url 'http://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.6.tar.bz2'
  sha1 '4f0cac0da585abddc222956cac1b6e508ca1c49e'
  head 'https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/tabix'

  def install
    system "make"
    bin.install %w{tabix bgzip}
    man1.install 'tabix.1'
    ln_s man1+'tabix.1', man1+'bgzip.1'
  end
end
