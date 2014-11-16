require 'formula'

# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/downloads/3.1.3/mpich-3.1.3.tar.gz'
  mirror 'http://fossies.org/linux/misc/mpich-3.1.3.tar.gz'
  sha1 'aa9907891ef4a4a584ab2f90a86775f29ca0dec0'

  head do
    url 'git://git.mpich.org/mpich.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  devel do
    url 'http://www.mpich.org/static/downloads/3.2a1/mpich-3.2a1.tar.gz'
    sha1 'aa54439bfb1c9b03231cb4d574b9365c94155293'
  end

  option 'disable-fortran', "Do not attempt to build Fortran bindings"
  option 'disable-shared', "Do not build shared libraries"

  depends_on :fortran unless build.include? 'disable-fortran'

  conflicts_with 'open-mpi', :because => 'both install mpi__ compiler wrappers'

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV['MPICH_AUTOTOOLS_DIR'] = HOMEBREW_PREFIX+'bin'
      system "./autogen.sh"
    end

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--mandir=#{man}"
    ]
    args << "--disable-fortran" if build.include? "disable-fortran"

    if build.include? 'disable-shared'
      args << "--disable-shared"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    # a better test would be to build and run a small MPI program
    system "#{bin}/mpicc", "-show"
  end
end
