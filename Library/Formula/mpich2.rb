require 'formula'

# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/downloads/3.0.4/mpich-3.0.4.tar.gz'
  mirror 'http://fossies.org/linux/misc/mpich-3.0.4.tar.gz'
  sha1 'e89cc8de89d18d5718f7b881f3835b5a0943f897'

  head do
    url 'git://git.mpich.org/mpich.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  devel do
    url 'http://www.mpich.org/static/downloads/3.1rc3/mpich-3.1rc3.tar.gz'
    sha1 '5dc3aff479df6b88328f9800652eae3b0ec587e7'
  end

  option 'disable-fortran', "Do not attempt to build Fortran bindings"
  option 'enable-shared', "Build shared libraries (default for versions > 3.0.4)"
  option 'disable-shared', "Do not build shared libraries (default for versions <= 3.0.4)"

  depends_on :fortran unless build.include? 'disable-fortran'

  conflicts_with 'open-mpi', :because => 'both install mpi__ compiler wrappers'

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
    end

    # MPICH configure up to version 3.0.4 defaults to "--disable-shared"
    if build.include? 'enable-shared'
      args << "--enable-shared"
    elsif build.include? 'disable-shared'
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
