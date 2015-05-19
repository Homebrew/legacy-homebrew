# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.1.4.tar.gz"
  sha256 "f68b5330e94306c00ca5a1c0e8e275c7f53517d01d6c524d51ce9359d240466b"
  revision 1

  bottle do
    sha256 "fd3cfd66a31d7e3232e1903c038d7029251b9160d2a283726f3bcd0450fb8bdc" => :yosemite
    sha256 "54b5883a605e937e3353b07d9e4f5b0d647f9cbc066c71ff3770a183fa958b9a" => :mavericks
    sha256 "a3eae4088fa4a05c09b7e9d295d4f8f4b785e5942bc493fec58afb0344a42713" => :mountain_lion
  end

  head do
    url "git://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.2b2/mpich-3.2b2.tar.gz"
    sha256 "8ef37f88bbcfab0e9e173c36745b79f4dbbc3409476773c4489670d82d923155"
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
      "--mandir=#{man}",
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
