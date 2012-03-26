require 'formula'

class Blast < Formula
  homepage 'http://blast.ncbi.nlm.nih.gov/'
  url 'ftp://ftp.ncbi.nih.gov/blast/executables/blast+/2.2.25/ncbi-blast-2.2.25+-src.tar.gz'
  version '2.2.25'
  md5 '01256b808e3af49a5087945b6a8c8293'

  def install
    cd 'c++' do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
