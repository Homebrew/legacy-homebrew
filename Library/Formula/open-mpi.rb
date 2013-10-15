require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.5.tar.bz2'
  sha1 '93859d515b33dd9a0ee6081db285a2d1dffe21ce'

  devel do
    url 'http://www.open-mpi.org/software/ompi/v1.7/downloads/openmpi-1.7.2.tar.bz2'
    sha1 '89676c1171784b1c26e1598caf88e87f897f6653'
  end

  option 'disable-fortran', 'Do not build the Fortran bindings'
  option 'test', 'Verify the build with make check'
  option 'enable-mpi-thread-multiple', 'Enable MPI_THREAD_MULTIPLE'
  option 'with-c++11', 'Build using C++11 compiler.' if build.devel?

  conflicts_with 'mpich2', :because => 'both install mpi__ compiler wrappers'

  depends_on :fortran unless build.include? 'disable-fortran'

  # Reported upstream at version 1.6, both issues
  # http://www.open-mpi.org/community/lists/devel/2012/05/11003.php
  # http://www.open-mpi.org/community/lists/devel/2012/08/11362.php
  fails_with :clang do
    build 425
    cause 'fails make check on Lion and ML'
  end if not build.devel?

  # Patch to avoid reserved string literals in C++11
  def patches
    DATA
  end if build.with? 'c++11'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-ipv6
    ]
    if build.include? 'disable-fortran'
      args << '--disable-mpi-f77' << '--disable-mpi-f90'
    end

    if build.include? 'enable-mpi-thread-multiple'
      args << '--enable-mpi-thread-multiple'
    end

    if build.with? 'c++11'
      if ENV.compiler != :clang
        onoe "C++11 requires Clang as compiler. Aborting."
        exit -1
      end

      ENV.append 'CXX', '-std=c++11 -stdlib=libc++'
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

__END__
diff -Naur openmpi-1.7.2/ompi/contrib/vt/vt/extlib/otf/tools/otfshrink/otfshrink.cpp openmpi-1.7.2.new/ompi/contrib/vt/vt/extlib/otf/tools/otfshrink/otfshrink.cpp
--- openmpi-1.7.2/ompi/contrib/vt/vt/extlib/otf/tools/otfshrink/otfshrink.cpp	2013-04-13 03:44:15.000000000 -0700
+++ openmpi-1.7.2.new/ompi/contrib/vt/vt/extlib/otf/tools/otfshrink/otfshrink.cpp	2013-07-25 15:40:08.000000000 -0700
@@ -54,7 +54,7 @@
 "      -V            show OTF version                                       \n",
 "      -i <file>     input file name                                        \n",
 "      -o <name>     namestub of the output file                            \n",
-"                    (default: "DEFAULT_OUTFILE")                           \n",
+"                    (default: " DEFAULT_OUTFILE ")                         \n",
 "      -l \"<list>\"   a list of processes in quotes                        \n",
 "                    to enable, i.e. keep in the copy,                      \n",
 "                    e.g. '-l \"1,2 4-8 3\",10 12-20'                       \n",
