require 'formula'

# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/downloads/3.0.4/mpich-3.0.4.tar.gz'
  mirror 'http://fossies.org/linux/misc/mpich-3.0.4.tar.gz'
  sha1 'e89cc8de89d18d5718f7b881f3835b5a0943f897'

  devel do
    url 'http://www.mpich.org/static/downloads/3.1b1/mpich-3.1b1.tar.gz'
    sha1 '4dc1dd10f81a30206182f3770cb229521dd1973c'
  end

  head 'git://git.mpich.org/mpich.git'

  option 'disable-fortran', "Do not attempt to build Fortran bindings"
  option 'enable-shared', "Build shared libraries in the stable version of MPICH"
  option 'disable-shared', "Do not build shared libraries in the devel or HEAD version of MPICH"

  # the HEAD version requires the autotools to be installed
  # (autoconf>=2.67, automake>=1.12.3, libtool>=2.4)
  if build.head?
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  depends_on :fortran unless build.include? 'disable-fortran'

  conflicts_with 'open-mpi', :because => 'both install mpi__ compiler wrappers'

  # fails with clang from Xcode 4.5.1 on 10.7 and 10.8 (see #15533)
  # linker bug appears to have been fixed by Xcode 4.6
  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Clang generates code that causes the linker to segfault when building
      MPICH with shared libraries.  Specific message:

          collect2: ld terminated with signal 11 [Segmentation fault: 11]
      EOS
  end if build.include? 'enable-shared' and build.stable?

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
    end

    # MPICH 3.0.x configure defaults to "--disable-shared"
    if build.include? 'enable-shared' and build.stable?
      args << "--enable-shared"
    end

    # MPICH 3.1.x configure defaults to "--enable-shared"
    if build.include? 'disable-shared' and not build.stable?
      args << "--disable-shared"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    # a better test would be to build and run a small MPI program
    system "#{bin}/mpicc", "-show"
  end
end
