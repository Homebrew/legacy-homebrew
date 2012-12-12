require 'formula'

class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/tarballs/1.5/mpich2-1.5.tar.gz'
  sha1 'be7448227dde5badf3d6ebc0c152b200998421e0'

  head 'https://svn.mcs.anl.gov/repos/mpi/mpich2/trunk'

  # the HEAD version requires the autotools to be installed
  # (autoconf>=2.67, automake>=1.12.3, libtool>=2.4)
  if build.head?
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  option 'disable-fortran', "Do not attempt to build Fortran bindings"
  option 'enable-shared', "Build shared libraries"

  # fails with clang from Xcode 4.5.1 on 10.7 and 10.8 (see #15533)
  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Clang generates code that causes the linker to segfault when building
      MPICH2 with shared libraries.  Specific message:

          collect2: ld terminated with signal 11 [Segmentation fault: 11]
      EOS
  end if build.include? 'enable-shared'

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH2, otherwise very bizarre build errors can occur
      ENV['MPICH2_AUTOTOOLS_DIR'] = (HOMEBREW_PREFIX+'bin')
      system "./autogen.sh"
    end

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--mandir=#{man}"
    ]
    if build.include? 'disable-fortran'
      args << "--disable-f77" << "--disable-fc"
    else
      ENV.fortran
    end

    # MPICH2 configure defaults to "--disable-shared"
    if build.include? 'enable-shared'
      args << "--enable-shared"
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
