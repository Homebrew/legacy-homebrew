class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"

  bottle do
    cellar :any_skip_relocation
    revision 4
    sha256 "ded69c7dac4bc8747e52dca37d6d561e55e3162649d3805572db0dc2f940a4b8" => :el_capitan
    sha256 "daf70656aa9ff8b2fb612324222aa6b5e900e2705c9f555198bcd8cd798d7dd0" => :yosemite
    sha256 "d153b3318754731ff5e91b45b2518c75880993fa9d1f312a03696e2c1de0c9d5" => :mavericks
    sha256 "37e77a2e7ca6d479f0a471d5f5d828efff621bd051c1884ff1363d77c5c4675e" => :mountain_lion
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
