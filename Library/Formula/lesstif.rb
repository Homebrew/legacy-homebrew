class Lesstif < Formula
  desc "Open source implementation of OSF/Motif"
  homepage "http://lesstif.sourceforge.net"
  url "https://downloads.sourceforge.net/project/lesstif/lesstif/0.95.2/lesstif-0.95.2.tar.bz2"
  sha256 "eb4aa38858c29a4a3bcf605cfe7d91ca41f4522d78d770f69721e6e3a4ecf7e3"

  bottle do
    revision 1
    sha256 "bc26ea0e27740c5b3a045b776737ff94ea0bc68b833fc013b92177511271bbcd" => :el_capitan
    sha256 "a9c9a7fe8261ddbf4830655e6a1a3baa8849669064b990d04338c7bcfb57e6c3" => :yosemite
    sha256 "b5650ec87b85ac2b36f8e9cb53a452af1ed28f939cf007b209b458773d0634a6" => :mavericks
    sha256 "07279be1550eef882ed3b9f751cdd152412e84285c5d4e719dfd7fa21c897046" => :mountain_lion
  end

  depends_on :x11
  depends_on "freetype"

  def install
    # LessTif does naughty, naughty, things by assuming we want autoconf macros
    # to live in wherever `aclocal --print-ac-dir` says they should.
    # Shame on you LessTif! *wags finger*
    inreplace "configure", "`aclocal --print-ac-dir`", "#{share}/aclocal"

    # 'sed' fails if LANG=en_US.UTF-8 as is often the case on Macs.
    # The configure script finds our superenv sed wrapper, sets SED,
    # but then doesn't use that variable.
    ENV["LANG"] = "C"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-production",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static"

    system "make"

    # LessTif won't install in parallel 'cause several parts of the Makefile will
    # try to make the same directory and `mkdir` will fail.
    ENV.deparallelize
    system "make", "install"
  end
end
