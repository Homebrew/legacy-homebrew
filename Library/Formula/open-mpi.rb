require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.4.tar.bz2'
  sha1 '38095d3453519177272f488d5058a98f7ebdbf10'

  devel do
    url 'http://www.open-mpi.org/software/ompi/v1.7/downloads/openmpi-1.7rc8.tar.bz2'
    sha1 '38b6f2598a071311ae6f5ccaf13dffd6154ccfff'
  end

  # Reported upstream at version 1.6, both issues
  # http://www.open-mpi.org/community/lists/devel/2012/05/11003.php
  # http://www.open-mpi.org/community/lists/devel/2012/08/11362.php
  fails_with :clang do
    build 421
    cause 'fails make check on Lion and ML'
  end if not build.devel?

  option 'disable-fortran', 'Do not build the Fortran bindings'
  option 'test', 'Verify the build with make check'
  option 'enable-mpi-thread-multiple', 'Enable MPI_THREAD_MULTIPLE'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-ipv6
    ]
    if build.include? 'disable-fortran'
      args << '--disable-mpi-f77' << '--disable-mpi-f90'
    else
      ENV.fortran
    end

    if build.include? 'enable-mpi-thread-multiple'
      args << '--enable-mpi-thread-multiple'
    end

    system './configure', *args
    system 'make V=1 all'
    system 'make V=1 check' if build.include? 'test'
    system 'make install'

    # If Fortran bindings were built, there will be a stray `.mod` file
    # (Fortran header) in `lib` that needs to be moved to `include`.
    include.install lib/'mpi.mod' if File.exists? "#{lib}/mpi.mod"

    # Not sure why the wrapped script has a jar extension - adamv
    libexec.install bin/'vtsetup.jar'
    bin.write_jar_script libexec/'vtsetup.jar', 'vtsetup.jar'
  end
end
