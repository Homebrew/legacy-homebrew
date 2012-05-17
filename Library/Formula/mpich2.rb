require 'formula'

class Mpich2 < Formula
  homepage 'http://www.mcs.anl.gov/research/projects/mpich2/index.php'
  url 'http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.4.1p1/mpich2-1.4.1p1.tar.gz'
  version '1.4.1p1'
  sha1 '8dcc8888fb27232eb8f76c11cc890f1c3c483804'
  head 'https://svn.mcs.anl.gov/repos/mpi/mpich2/trunk'

  devel do
    url 'http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.5b1/mpich2-1.5b1.tar.gz'
    version '1.5b1'
    sha1 'd9dfc992657c3cbe5b40374fd8aaa553ebaf5402'
  end

  # the HEAD version requires the autotools to be installed
  # (autoconf>=2.67, automake>=1.11, libtool>=2.4)
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
    unless ARGV.build_devel? or ARGV.build_head?
      # parallel builds are broken prior to version 1.5a1
      ENV.deparallelize
    end

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
