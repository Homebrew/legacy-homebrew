class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"
  url "https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.1.tar.bz2"
  sha256 "7919ecde15962bab2e26d01d5f5f4ead6696bbcacb504b8560f2e3a152bfe492"

  bottle do
    sha256 "257a75a3227ddc0b5e7c970a97c76cadeda417a259c54efbe25df955e0efe32b" => :el_capitan
    sha256 "2c9afac3f1350e4693e2077fa3b5a6f149fc0b0cb19e804bba15cd8d00e62456" => :yosemite
    sha256 "7c106ab43c8aa5fcde2d9961a084c4c34d5a8ea1888668d825ce1ec818519e29" => :mavericks
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option :cxx11

  conflicts_with "mpich", :because => "both install mpi__ compiler wrappers"
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
    args << "--with-platform-optimized" if build.head?
    args << "--disable-mpi-fortran" if build.without? "fortran"
    args << "--enable-mpi-thread-multiple" if build.with? "mpi-thread-multiple"

    system "./autogen.pl" if build.head?
    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # If Fortran bindings were built, there will be stray `.mod` files
    # (Fortran header) in `lib` that need to be moved to `include`.
    include.install Dir["#{lib}/*.mod"]

    if build.stable?
      # Move vtsetup.jar from bin to libexec.
      libexec.install bin/"vtsetup.jar"
      inreplace bin/"vtsetup", "$bindir/vtsetup.jar", "$prefix/libexec/vtsetup.jar"
    end
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
