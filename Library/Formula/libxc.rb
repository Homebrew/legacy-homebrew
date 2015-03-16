class Libxc < Formula
  homepage "http://www.tddft.org/programs/octopus/wiki/index.php/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.2.tar.gz"
  sha256 "6ca1d0bb5fdc341d59960707bc67f23ad54de8a6018e19e02eee2b16ea7cc642"

  bottle do
    cellar :any
    sha1 "552995f0f0415f65369e20c02d65ce521289fb2f" => :yosemite
    sha1 "3b2aea28723d7fc6240582f7363eceb1f71bc4ac" => :mavericks
    sha1 "92761485a4a6e72b8340c6a4f0ec394a62cfb4b4" => :mountain_lion
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
