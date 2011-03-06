require 'formula'

class Samtools <Formula
  url 'http://sourceforge.net/projects/samtools/files/samtools/0.1.12/samtools-0.1.12a.tar.bz2'
  homepage 'http://samtools.sourceforge.net/'
  md5 '500ae32fb431de3940e0e955744b9b36'

  def install
    # -s is needed on OS X here.
    inreplace ["Makefile", "bcftools/Makefile"], "$(AR)", "$(AR) -s"

    system "make"
    system "make razip"

    bin.install %w{samtools razip}
    prefix.install %w{examples misc}
    lib.install 'libbam.a'
    (include+'bam').install Dir['*.h']
  end
end
