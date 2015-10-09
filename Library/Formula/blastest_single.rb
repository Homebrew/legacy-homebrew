class BlastestSingle < Formula
  desc "blas test for veclibfort (single)"
  homepage "https://tds.xyz"
  url "https://gist.githubusercontent.com/davydden/1f9ebf3692beca2438f8/raw/0ba39c8775db3bb21c09c3440bf78ff5f778277d/blas.f90"
  sha256 "9fad00d1d7e8d5d0be3c16fd25755c5d089205fae9dd4716481f8072a6a7f954"
  version "1.0"

  depends_on :fortran
  depends_on :blas => :fortran

  def install
    blas_names = ENV["HOMEBREW_BLASLAPACK_NAMES"]
    blas_lib   = ENV["HOMEBREW_BLASLAPACK_LIB"]
    blas_inc   = ENV["HOMEBREW_BLASLAPACK_INC"]
    ldflags    = blas_lib != "" ? "-L#{blas_lib} " : ""
    ldflags   += blas_names.split(";").map { |word| "-l#{word}" }.join(" ")
    ldflags   += " -pthread -lm"
    cflags     = blas_inc != "" ? "-I#{blas_inc}"  : ""
    system "#{ENV.fc} blas.f90 #{cflags} -o blastest_single #{ldflags}"
    bin.install "blastest_single"
  end
 
  test do
    system bin/"blastest_single"
  end
end
