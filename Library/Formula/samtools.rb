require 'formula'

class Samtools < Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.14/samtools-0.1.14.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 'aa2bed7b3d96e64cbeb3726f1fb6d880'

  def install
    system "make"
    system "make razip"

    bin.install %w{samtools razip}
    prefix.install %w{examples misc NEWS}
    lib.install 'libbam.a'
    (include+'bam').install Dir['*.h']
    man1.install 'samtools.1'
  end
end
