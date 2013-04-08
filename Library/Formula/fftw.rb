require 'formula'

class Fftw < Formula
  homepage 'http://www.fftw.org'
  url 'http://www.fftw.org/fftw-3.3.3.tar.gz'
  sha1 '11487180928d05746d431ebe7a176b52fe205cf9'

  option "with-fortran", "Enable Fortran bindings"

  def install
    args = ["--enable-shared",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--enable-threads",
            "--disable-dependency-tracking"]

    simd_args = ["--enable-sse2"]
    simd_args << "--enable-avx" if ENV.compiler == :clang and Hardware::CPU.avx? and !ARGV.build_bottle?

    if build.include? "with-fortran"
      ENV.fortran
    else
      args << "--disable-fortran" unless which 'gfortran'
    end

    # single precision
    # enable-sse2 works for both single and double precisions
    system "./configure", "--enable-single", *(args + simd_args)
    system "make install"

    # clean up so we can compile the double precision variant
    system "make clean"

    # double precision
    # enable-sse2 works for both single and double precisions
    system "./configure", *(args + simd_args)
    system "make install"

    # clean up so we can compile the long-double precision variant
    system "make clean"

    # long-double precision
    # no SIMD optimization available
    system "./configure", "--enable-long-double", *args
    system "make install"
  end
end
