require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.7/downloads/openmpi-1.7.3.tar.bz2'
  sha1 'ce61ee466ac2b21024c7d8dabc4f18676b2f1b76'

  option 'disable-fortran', 'Do not build the Fortran bindings'
  option 'enable-mpi-thread-multiple', 'Enable MPI_THREAD_MULTIPLE'
  option :cxx11

  conflicts_with 'mpich2', :because => 'both install mpi__ compiler wrappers'
  conflicts_with 'lcdf-typetools', :because => 'both install same set of binaries.'

  depends_on :fortran unless build.include? 'disable-fortran'

  def patches
    # Do not install the libevent header files.
    # See http://www.open-mpi.org/community/lists/users/2013/11/22900.php
    DATA
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
    ]
    if build.include? 'disable-fortran'
      args << '--disable-mpi-f77' << '--disable-mpi-f90'
    end

    if build.include? 'enable-mpi-thread-multiple'
      args << '--enable-mpi-thread-multiple'
    end

    system './configure', *args
    system 'make', 'all'
    system 'make', 'check'
    system 'make', 'install'

    # If Fortran bindings were built, there will be a stray `.mod` file
    # (Fortran header) in `lib` that needs to be moved to `include`.
    include.install lib/'mpi.mod' if File.exist? "#{lib}/mpi.mod"

    # Not sure why the wrapped script has a jar extension - adamv
    libexec.install bin/'vtsetup.jar'
    bin.write_jar_script libexec/'vtsetup.jar', 'vtsetup.jar'
  end
end

__END__

diff --git a/opal/mca/event/libevent2021/libevent/include/Makefile.in b/opal/mca/event/libevent2021/libevent/include/Makefile.in
index 99fb60b..5f7cad0 100644
--- a/opal/mca/event/libevent2021/libevent/include/Makefile.in
+++ b/opal/mca/event/libevent2021/libevent/include/Makefile.in
@@ -281,10 +281,10 @@ EVENT2_EXPORT = \
 	event2/util.h
 
 EXTRA_SRC = $(EVENT2_EXPORT)
-@INSTALL_LIBEVENT_TRUE@nobase_include_HEADERS = $(EVENT2_EXPORT)
-@INSTALL_LIBEVENT_TRUE@nobase_nodist_include_HEADERS = ./event2/event-config.h
-@INSTALL_LIBEVENT_FALSE@noinst_HEADERS = $(EVENT2_EXPORT)
-@INSTALL_LIBEVENT_FALSE@nodist_noinst_HEADERS = ./event2/event-config.h
+#@INSTALL_LIBEVENT_TRUE@nobase_include_HEADERS = $(EVENT2_EXPORT)
+#@INSTALL_LIBEVENT_TRUE@nobase_nodist_include_HEADERS = ./event2/event-config.h
+#@INSTALL_LIBEVENT_FALSE@noinst_HEADERS = $(EVENT2_EXPORT)
+#@INSTALL_LIBEVENT_FALSE@nodist_noinst_HEADERS = ./event2/event-config.h
 all: all-am
 
 .SUFFIXES:
