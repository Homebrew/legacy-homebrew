require 'formula'

class Mpich2 < Formula
  homepage 'http://www.mcs.anl.gov/research/projects/mpich2/index.php'
  url 'http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.4.1p1/mpich2-1.4.1p1.tar.gz'
  version '1.4.1p1'
  md5 'b470666749bcb4a0449a072a18e2c204'

  def options
    [
      ['--disable-fortran', "Do not attempt to build Fortran bindings"],
    ]
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--enable-shared"
    ]
    if ARGV.include? '--disable-fortran'
      args << "--disable-f77" << "--disable-fc"
    else
      ENV.fortran
    end

    system "./configure", *args
    system "make"
    system "make install"

    # MPE installs several helper scripts like "mpeuninstall" to the sbin
    # directory, which we don't need when installing via homebrew
    sbin.rmtree
  end

  def caveats; <<-EOS.undent
    Please be aware that installing this formula along with the `openmpi`
    formula will cause neither MPI installation to work correctly as
    both packages install their own versions of mpicc/mpicxx and mpirun.
    EOS
  end

  def test
    # a better test would be to build and run a small MPI program
    system "#{bin}/mpicc", "-show"
  end
end
