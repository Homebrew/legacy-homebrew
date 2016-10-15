require "formula"

class P4est < Formula
  homepage "http://www.p4est.org"
  url "http://p4est.github.io/release/p4est-0.3.4.2.tar.gz"
  sha1 "841f71e68c57fb8608c4cd3159c7eff4b8fe93d7"

  depends_on "cmake" => :build
  depends_on :mpi => :cc

  def install
    ENV['CC']  = '#{HOMEBREW_PREFIX}/bin/mpicc'
    ENV['CXX'] = '#{HOMEBREW_PREFIX}/bin/mpic++'

    system "./configure", "--enable-mpi",
                          "--enable-shared",
                          "--disable-vtk-binary",
                          "--without-blas",
                          "--prefix=#{prefix}"

    system "make", "install"

  end

end
