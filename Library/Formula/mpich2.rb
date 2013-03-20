require 'formula'

# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/tarballs/3.0.2/mpich-3.0.2.tar.gz'
  sha1 '510f5a05bb5c8214caa86562e054c455cb5287d1'

  head 'git://git.mpich.org/mpich.git'

  # the HEAD version requires the autotools to be installed
  # (autoconf>=2.67, automake>=1.12.3, libtool>=2.4)
  if build.head?
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  option 'disable-fortran', "Do not attempt to build Fortran bindings"
  option 'enable-shared', "Build shared libraries"

  # fails with clang from Xcode 4.5.1 on 10.7 and 10.8 (see #15533)
  # linker bug appears to have been fixed by Xcode 4.6
  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Clang generates code that causes the linker to segfault when building
      MPICH with shared libraries.  Specific message:

          collect2: ld terminated with signal 11 [Segmentation fault: 11]
      EOS
  end if build.include? 'enable-shared'

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV['MPICH_AUTOTOOLS_DIR'] = (HOMEBREW_PREFIX+'bin')
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

    # MPICH configure defaults to "--disable-shared"
    if build.include? 'enable-shared'
      args << "--enable-shared"
    end

    system "./configure", *args
    system "make"
    system "make install"
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
