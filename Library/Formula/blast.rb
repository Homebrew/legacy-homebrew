require 'formula'

class Blast < Formula
  url 'ftp://ftp.ncbi.nih.gov/blast/executables/blast+/2.2.25/ncbi-blast-2.2.25+-src.tar.gz'
  homepage 'http://blast.ncbi.nlm.nih.gov/'
  md5 '01256b808e3af49a5087945b6a8c8293'
  version '2.2.25'

  def install
    Dir.chdir 'c++' do
      system "./configure --prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
