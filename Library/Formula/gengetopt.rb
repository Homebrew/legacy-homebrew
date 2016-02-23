class Gengetopt < Formula
  desc "Generate C code to parse command-line arguments via getopt_long"
  homepage "https://www.gnu.org/software/gengetopt/"
  url "http://ftpmirror.gnu.org/gengetopt/gengetopt-2.22.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.22.6.tar.gz"
  sha256 "30b05a88604d71ef2a42a2ef26cd26df242b41f5b011ad03083143a31d9b01f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "b551e59fe1e883d0c5e06ddb441777d3c07a60a9305fa08eaedcfd326f55ef26" => :el_capitan
    sha256 "74b81ccbfb9811f2f5a91218685f2fa19bef0c0970458fa2d2e07b3ea72bd5ef" => :yosemite
    sha256 "55332e9f5e24e737976f0212776ddc0d6609bed62eaef4ac80884eaa5171ef76" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ggo = <<-EOS.undent
      package "homebrew"
      version "0.9.5"
      purpose "The missing package manager for OS X"

      option "verbose" v "be verbose"
    EOS

    pipe_output("#{bin}/gengetopt --file-name=test", ggo, 0)
    assert File.exist? "test.h"
    assert File.exist? "test.c"
    assert_match(/verbose_given/, File.read("test.h"))
  end
end
