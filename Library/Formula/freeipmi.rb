class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.4.8.tar.gz"
  sha1 "64f3400922a273f4b2f591b13517608876b6bf98"

  bottle do
    sha1 "338a3c360926a64e1fb640ba06b53cc8ac79b7fc" => :yosemite
    sha1 "72f1e7eaabce2f847e73dc89b6edcc93c68d6d0f" => :mavericks
    sha1 "d2423644d16dcb7d61cb3a4221b176e72a8728dc" => :mountain_lion
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    # This is a big hammer to disable building the man pages
    # It breaks under homebrew's build system and I'm not sure why
    inreplace "man/Makefile", "install: install-am", "install:"
    system "make", "install"
  end

  test do
    system "#{sbin}/ipmi-fru", "--version"
  end
end
