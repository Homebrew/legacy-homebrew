class Scsh < Formula
  desc "Scheme shell"
  homepage "https://scsh.net/"
  url "https://ftp.scsh.net/pub/scsh/0.6/scsh-0.6.7.tar.gz"
  sha256 "c4a9f7df2a0bb7a7aa3dafc918aa9e9a566d4ad33a55f0192889de172d1ddb7f"

  bottle do
    sha256 "8644323a340e0161ea5669062ff0154bdf606b87a9fb5c83b37e65ce13fff14f" => :el_capitan
    sha256 "823dc978c21a886e0491a52ac62981cc62bcf1b0ec07e9bb597f072ba368e04c" => :yosemite
    sha256 "fe8e8159c830ad3e504ae6e211d66e3ab9abcb52619c9c186c1c84df0a2565d1" => :mavericks
  end

  head do
    url "https://github.com/scheme/scsh.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "scheme48"
  end

  conflicts_with "scheme48", :because => "both install include/scheme48.h"

  def install
    if build.head?
      system "autoreconf"
    else
      # will not build 64-bit
      ENV.m32
    end

    # build system is not parallel-safe
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
