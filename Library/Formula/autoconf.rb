class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"

  bottle do
    cellar :any
    revision 3
    sha256 "d3b15c0b1aec975ab3274b99ba9202122842fc08c62a266dcfb71501083e3a84" => :el_capitan
    sha256 "5c00e4a1c7a3fe918ef743c7ca70e772432a2cc3e40eb0737283d94e2db8f555" => :yosemite
    sha256 "13810d9363887d21b2d7bfaaccfc52853a4ca021b0d020a9764c32eb0cda256a" => :mavericks
    sha256 "79a026a91be5ae3927e60d01c666e71f8e78f46cc02dda95770d17c92b5b87af" => :mountain_lion
  end

  keg_only :provided_until_xcode43

  def install
    ENV["PERL"] = "/usr/bin/perl"

    # force autoreconf to look for and use our glibtoolize
    inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
    # also touch the man page so that it isn't rebuilt
    inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"

    system "./configure", "--prefix=#{prefix}",
           "--with-lispdir=#{share}/emacs/site-lisp/autoconf"
    system "make", "install"

    rm_f info/"standards.info"
  end

  test do
    cp "#{share}/autoconf/autotest/autotest.m4", "autotest.m4"
    system "#{bin}/autoconf", "autotest.m4"
  end
end
