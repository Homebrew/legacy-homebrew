# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.1.4.tar.gz"
  sha256 "f68b5330e94306c00ca5a1c0e8e275c7f53517d01d6c524d51ce9359d240466b"
  revision 1

  bottle do
    revision 1
    sha256 "b9a72ad2144103682aa485cada4d429c4f9397ffa94e5935d3fb44a59d54f18d" => :yosemite
    sha256 "17b5fbbc2e19645ab9b20c39c7da8c02ca44addc5df7de020cf5b17acfa5c681" => :mavericks
    sha256 "733c9baca04fcb032a8eb0fc812b429c1f54430f9cf4534814df1f0941aa8194" => :mountain_lion
  end

  head do
    url "git://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.2b4/mpich-3.2b4.tar.gz"
    sha256 "4fecce31b02095643a093aa01900fc1c6dec7690259c7459cc423f0ed10e949b"
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
