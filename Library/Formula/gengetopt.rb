class Gengetopt < Formula
  desc "Generate C code to parse command-line arguments via getopt_long"
  homepage "https://www.gnu.org/software/gengetopt/"
  url "http://ftpmirror.gnu.org/gengetopt/gengetopt-2.22.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.22.6.tar.gz"
  sha256 "30b05a88604d71ef2a42a2ef26cd26df242b41f5b011ad03083143a31d9b01f7"

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
