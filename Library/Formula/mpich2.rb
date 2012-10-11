require 'formula'

class Mpich2 < Formula
  homepage 'http://www.mcs.anl.gov/research/projects/mpich2/index.php'
  url 'http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.5/mpich2-1.5.tar.gz'
  version '1.5'
  sha1 'be7448227dde5badf3d6ebc0c152b200998421e0'
  head 'https://svn.mcs.anl.gov/repos/mpi/mpich2/trunk'

  # the HEAD version requires the autotools to be installed
  # (autoconf>=2.67, automake>=1.12.3, libtool>=2.4)
  if ARGV.build_head?
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  def options
    [
      ['--disable-fortran', "Do not attempt to build Fortran bindings"],
    ]
  end

  def install
    if ARGV.build_head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH2, otherwise very bizarre build errors can occur
      ENV['MPICH2_AUTOTOOLS_DIR'] = (HOMEBREW_PREFIX+'bin')
      system "./autogen.sh"
    end

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
