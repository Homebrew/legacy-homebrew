require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.3.tar.bz2'
  sha1 '4be9c5d2a8baee6a80bde94c6485931979a428fe'
  revision 1

  bottle do
    revision 1
    sha1 "6f2e83991f28267fb693fdd840d6db244c39c1ad" => :yosemite
    sha1 "605dc42b155eeda69592be9b63524a4323ebfaf5" => :mavericks
    sha1 "4bd58e35a701b7b9bca3092d852b746e5975a866" => :mountain_lion
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
