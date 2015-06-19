class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  # Wait for 1.8.6 and skip 1.8.5 due to a severe memory leak on OS X:
  # https://github.com/open-mpi/ompi/issues/579
  url "https://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.4.tar.bz2"
  sha256 "23158d916e92c80e2924016b746a93913ba7fae9fff51bf68d5c2a0ae39a2f8a"
  revision 1

  bottle do
    revision 1
    sha256 "78d4850f74cc2c6043bc3fb77cb431dcb43edde4bd898640840aa444c3268e6e" => :yosemite
    sha256 "21c9b28a601b07a0c5ac85b5155e79d4e083f233dbddfe5a62a5274d24b40866" => :mavericks
    sha256 "b2d256bf0430a7a3853683354137102f5ab5d8ba729f8e889877763e65dd7d22" => :mountain_lion
  end

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option :cxx11

  conflicts_with "mpich2", :because => "both install mpi__ compiler wrappers"
  conflicts_with "lcdf-typetools", :because => "both install same set of binaries."

  depends_on :java => :build
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
      --with-sge
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
