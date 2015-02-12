class Ga < Formula
  homepage "http://hpc.pnl.gov/globalarrays/"
  url "http://hpc.pnl.gov/globalarrays/download/ga-5-3.tgz"
  version "5.3"
  sha1 "b4e5fdc7f25e76d4d9e4c8b23f9c9ae2855cd925"

  depends_on "gcc"
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f77, :f90] # mpich must have been installed with GNU gcc, ie brew install --build-from-source --cc=gcc-${gccversion} --cxx=g++-${gccversion} mpich2

  def install
    ENV["PATH"] = "/usr/local/bin:" + ENV["PATH"]
    system("mpicc -v 2>&1 | grep 'Homebrew gcc'>/dev/null || { gccversion=$(/usr/local/bin/brew info gcc|egrep '^gcc:' | sed -e 's/gcc: *[a-z0-9]* *//' -e 's/\.[0-9] .*$//'); mpicc -v 2>&1; echo mpich2 must be installed with GNU gcc-${gccversion}; echo Please consider doing; echo brew reinstall --build-from-source --cc=gcc-${gccversion} --cxx=g++-${gccversion} mpich2; exit 1; }")

    system "./configure",
           "CC=mpicc",
           "FC=mpif90",
           "F77=mpif77",
           "CXX=mpicxx",
           "MPICC=mpicc",
           "MPIFC=mpif90",
           "MPIF77=mpif77",
           "MPICXX=mpicxx",
           "--enable-cxx",
           "--prefix=#{prefix}"
    system "make"
    #system "make check MPIEXEC='mpiexec -np 2'"
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        int testpattern;
        int pattern=999;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        GA_Initialize();
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        testpattern=pattern;
        GA_Brdcst(&testpattern,sizeof(testpattern),0);
        printf("[%d/%d] Hello, world! My name is %s; broadcast error=%d.\\n", rank, size, name,testpattern-pattern);
        GA_Terminate();
        MPI_Finalize();
        return testpattern != pattern;
      }
    EOS
    ldflags = `#{bin}/ga-config --ldflags --libs`
    system("mpicc hello.c -o hello "+ldflags)
    system "./hello"
    system "mpirun", "-np", "4", "./hello"
  end
end
