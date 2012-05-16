require 'formula'

class Mpich2 < Formula
  url 'http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.4.1p1/mpich2-1.4.1p1.tar.gz'
  homepage 'http://www.mcs.anl.gov/research/projects/mpich2/index.php'
  md5 'b470666749bcb4a0449a072a18e2c204'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-f77", "--disable-fc", "--with-device=ch3:nemesis", "--enable-shared"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS
Please be aware that installing this formula along with the OpenMPI
formula will cause neither MPI installation to work correctly as
both packages install their own versions of mpicc/mpicxx and mpirun.
    EOS
  end
end
