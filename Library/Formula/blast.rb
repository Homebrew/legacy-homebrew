require 'formula'

class Blast < Formula
  url 'ftp://ftp.ncbi.nih.gov/blast/executables/blast+/2.2.24/ncbi-blast-2.2.24+-src.tar.gz'
  homepage 'http://blast.ncbi.nlm.nih.gov/Blast.cgi'
  md5 '8877bf01a7370ffa01b5978b8460a4d9'
  version '2.2.24'

  def install
    Dir.chdir 'c++' do
      system "./configure --prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
