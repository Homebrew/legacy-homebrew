# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.1.4.tar.gz"
  sha1 "af4f563e2772d610e57e17420c9dcc5c3c9fec4e"

  bottle do
    sha1 "96a6ef7dff3f1902790317124ff608c481a2a885" => :yosemite
    sha1 "041e7aabd743689d14dd460d1cc290763f820a44" => :mavericks
    sha1 "322ea98717bd9cccc060d12f7e4d655c87b601b4" => :mountain_lion
  end

  head do
    url "git://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.2b2/mpich-3.2b2.tar.gz"
    sha1 "8e954e54d1c1a08ef7d042c18ed308d566e32cd5"
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
