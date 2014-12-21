require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.4.tar.bz2'
  sha1 '88ae39850fcf0db05ac20e35dd9e4cacc75bde4d'

  bottle do
    sha1 "a6ec98d40ab34bf2eb4dbe9223d5aa430ba749ed" => :yosemite
    sha1 "9d7366e69787c6b331fe5473c8025d86d8b79691" => :mavericks
    sha1 "8c8627010c9390cb72054fba3f8eea419a67bb2b" => :mountain_lion
  end

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option :cxx11

  conflicts_with 'mpich2', :because => 'both install mpi__ compiler wrappers'
  conflicts_with 'lcdf-typetools', :because => 'both install same set of binaries.'

  depends_on :fortran => :recommended
  depends_on 'libevent'

  def install
    ENV.cxx11 if build.cxx11?

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
      --with-libevent=#{Formula["libevent"].opt_prefix}
    ]
    args << "--disable-mpi-fortran" if build.without? "fortran"
    args << "--enable-mpi-thread-multiple" if build.with? "mpi-thread-multiple"

    system './configure', *args
    system 'make', 'all'
    system 'make', 'check'
    system 'make', 'install'

    # If Fortran bindings were built, there will be stray `.mod` files
    # (Fortran header) in `lib` that need to be moved to `include`.
    include.install Dir["#{lib}/*.mod"]

    # Move vtsetup.jar from bin to libexec.
    libexec.install bin/'vtsetup.jar'
    inreplace bin/'vtsetup', '$bindir/vtsetup.jar', '$prefix/libexec/vtsetup.jar'
  end
end
