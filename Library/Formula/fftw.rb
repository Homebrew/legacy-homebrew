class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://www.fftw.org/fftw-3.3.4.tar.gz"
  sha256 "8f0cde90929bc05587c3368d2f15cd0530a60b8a9912a8e2979a72dbe5af0982"
  revision 1

  bottle do
    cellar :any
    sha256 "92f9c2aea12100ba53084c5fe886418c348ab744fd47b60a9cee9c922044942b" => :el_capitan
    sha256 "14ba3f3d52df54d350a009ff1e65859095b99b31da996c52155bb3f2420716ad" => :yosemite
    sha256 "e32ceb93872580935d6e63878717ce35c964a21fdd0a6a93b29715f6aafb6811" => :mavericks
    sha256 "bb29553043cc4db9c38e0290215fb216facb5ae09a4c3dadf3b19a41df161764" => :mountain_lion
  end

  option "with-fortran", "Enable Fortran bindings"
  option :universal
  option "with-mpi", "Enable MPI parallel transforms"
  option "with-openmp", "Enable OpenMP parallel transforms"

  depends_on :fortran => :optional
  depends_on :mpi => [:cc, :optional]
  needs :openmp if build.with? "openmp"

  def install
    args = ["--enable-shared",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--enable-threads",
            "--disable-dependency-tracking",
           ]
    simd_args = ["--enable-sse2"]
    simd_args << "--enable-avx" if ENV.compiler == :clang && Hardware::CPU.avx? && !build.bottle?

    args << "--disable-fortran" if build.without? "fortran"
    args << "--enable-mpi" if build.with? "mpi"
    args << "--enable-openmp" if build.with? "openmp"

    ENV.universal_binary if build.universal?

    # single precision
    # enable-sse2 and enable-avx works for both single and double precision
    system "./configure", "--enable-single", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the double precision variant
    system "make", "clean"

    # double precision
    # enable-sse2 and enable-avx works for both single and double precision
    system "./configure", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the long-double precision variant
    system "make", "clean"

    # long-double precision
    # no SIMD optimization available
    system "./configure", "--enable-long-double", *args
    system "make", "install"
  end

  test do
    # Adapted from the sample usage provided in the documentation:
    # http://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html
    (testpath/"fftw.c").write <<-TEST_SCRIPT.undent
      #include <fftw3.h>
      int main(int argc, char* *argv)
      {
          fftw_complex *in, *out;
          fftw_plan p;
          long N = 1;
          in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
          fftw_execute(p); /* repeat as needed */
          fftw_destroy_plan(p);
          fftw_free(in); fftw_free(out);
          return 0;
      }
    TEST_SCRIPT

    system ENV.cc, "-o", "fftw", "fftw.c", "-lfftw3", *ENV.cflags.to_s.split
    system "./fftw"
  end
end
