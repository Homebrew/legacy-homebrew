class OpenMpi < Formula
  homepage "http://www.open-mpi.org/"
  url "http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.5.tar.bz2"
  sha256 "4cea06a9eddfa718b09b8240d934b14ca71670c2dc6e6251a585ce948a93fbc4"

  bottle do
    sha256 "cb257e6d49ebd40af7b9cfefb08547df5278e4db70463d3adac341811620ae4a" => :yosemite
    sha256 "e0918c53d587f92c7ad43f2841992b06bade41f5b4adfe3f46367b7f244e04ab" => :mavericks
    sha256 "df0ac28d6a1149cf21172f7ee2d32e36113e2ec257b3efb003831f333d42f43c" => :mountain_lion
  end

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option :cxx11

  conflicts_with "mpich2", :because => "both install mpi__ compiler wrappers"
  conflicts_with "lcdf-typetools", :because => "both install same set of binaries."

  depends_on :fortran => :recommended
  depends_on "libevent"

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

    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # If Fortran bindings were built, there will be stray `.mod` files
    # (Fortran header) in `lib` that need to be moved to `include`.
    include.install Dir["#{lib}/*.mod"]

    # Move vtsetup.jar from bin to libexec.
    libexec.install bin/"vtsetup.jar"
    inreplace bin/"vtsetup", "$bindir/vtsetup.jar", "$prefix/libexec/vtsetup.jar"
  end

  def caveats; <<-EOS.undent
    WARNING: Open MPI now ignores the F77 and FFLAGS environment variables.
    Only the FC and FCFLAGS environment variables are used.
    EOS
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        printf("[%d/%d] Hello, world! My name is %s.\\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    EOS
    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"
  end
end
