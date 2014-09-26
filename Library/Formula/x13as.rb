require "formula"

class X13as < Formula
  homepage "http://www.census.gov/srd/www/x13as/x13down_unix.html"
  url "http://www.census.gov/ts/x13as/unix/x13assrc.tar.gz"
  sha1 "18fa711967af84f51a93ecaa41e43f05e5d973e1"
  version "1.1.9"

  depends_on :fortran

  def install
    args = %W[
      --file=makefile.g77
      FC=gfortran
      LINKER=gfortran
    ]

    system "make", *args
    bin.install "x13as"
  end
end
