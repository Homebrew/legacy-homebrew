require 'formula'

# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/downloads/3.1/mpich-3.1.tar.gz'
  mirror 'http://fossies.org/linux/misc/mpich-3.1.tar.gz'
  sha1 'ac3e79482b7645f9512f687404e9be29855258e9'

  head do
    url 'git://git.mpich.org/mpich.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  devel do
    url 'http://www.mpich.org/static/downloads/3.1/mpich-3.1.tar.gz'
    sha1 'ac3e79482b7645f9512f687404e9be29855258e9'
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
    if build.include? 'disable-fortran'
      args << "--disable-f77" << "--disable-fc"
    end

    # MPICH configure up to version 3.0.4 defaults to "--disable-shared"
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
