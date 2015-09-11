class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"

  bottle do
    revision 2
    sha1 "3f83cb206720445748c0c4851152607bfabaa926" => :yosemite
    sha1 "319a4ac05d83b5b3db37dcc629a46a412ec1989b" => :mavericks
    sha1 "83184a596d69f3a868e6780c1c8fba309ea28fb2" => :mountain_lion
    sha1 "7d31f63e5ddd1bbbf0397b0b70df1ff9e70f998b" => :lion
  end

  keg_only :provided_until_xcode43

  def install
    ENV["PERL"] = "/usr/bin/perl"

    # force autoreconf to look for and use our glibtoolize
    inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
    # also touch the man page so that it isn't rebuilt
    inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    rm_f info/"standards.info"
  end

  test do
    cp "#{share}/autoconf/autotest/autotest.m4", "autotest.m4"
    system "#{bin}/autoconf", "autotest.m4"
  end
end
