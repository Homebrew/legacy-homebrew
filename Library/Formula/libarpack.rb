require 'formula'

class Libarpack < Formula
  homepage 'http://http://forge.scilab.org/index.php/p/arpack-ng/'
  url 'http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_3.1.2.tar.gz'
  sha1 'f5453e2d576f131890ca023e1d853e18920f9c3c'
  head 'git://git.forge.scilab.org/arpack-ng.git'

  option 'with-mpi', 'build parallel version of arpack with MPI'
  depends_on 'open-mpi' if build.include? 'with-mpi'

  def install
    ENV.fortran

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--enable-mpi" if build.include? 'with-mpi'

    system "./configure", *args
    system "make install"

    # remove test binary after install
    rm bin/'dnsimp'
  end
end
