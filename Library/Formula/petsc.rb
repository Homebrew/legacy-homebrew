require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.1-p8.tar.gz'
  sha1 'bfd083a85753366bc349808eb72eab1b8cc66944'

  depends_on 'open-mpi'

  def install
    ENV.j1

    system "./configure", "--with-debugging=0", "--prefix=#{prefix}",
                          "--with-fc=0" # Tests fail with fortran enabled 
    system "make all"
    system "make test"
    system "make install"
  end
end
