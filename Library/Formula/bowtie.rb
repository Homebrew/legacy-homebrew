require 'formula'

class Bowtie <Formula
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie/0.12.5/bowtie-0.12.5-src.zip'
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  md5 'c3c633b60f82a775226c1d6b27813315'

  def install
    system "make"
    bin.install ["bowtie", "bowtie-build", "bowtie-inspect"]
  end
end
