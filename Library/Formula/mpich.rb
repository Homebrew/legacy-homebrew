class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.1.4.tar.gz"
  sha256 "f68b5330e94306c00ca5a1c0e8e275c7f53517d01d6c524d51ce9359d240466b"
  revision 1

  bottle do
    sha256 "52f8f331dbb01514fca1d7921c38c6cab2dd77b06ee6a0c42e608d0719041aeb" => :yosemite
    sha256 "2d99e877646cc27a13dd4b901050d1e1f5a716f2b2c775cbeaec263886a2d12d" => :mavericks
    sha256 "56070798b3958bced4b32c3ef3c21f21b07df5e0f14389645d4ba03119d09a78" => :mountain_lion
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.2b4/mpich-3.2b4.tar.gz"
    sha256 "4fecce31b02095643a093aa01900fc1c6dec7690259c7459cc423f0ed10e949b"
  end

  head do
    url "git://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end
  deprecated_option "disable-fortran" => "without-fortran"

  depends_on :fortran => :recommended

  conflicts_with "open-mpi", :because => "both install mpi__ compiler wrappers"

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--mandir=#{man}"
    ]

    args << "--disable-fortran" if build.without? "fortran"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
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
