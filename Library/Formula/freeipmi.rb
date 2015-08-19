class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.4.9.tar.gz"
  sha256 "178b11ea24d59337581dbb827551deb2fa4ed8f551656300fa66573123775d6c"

  bottle do
    sha256 "35a7f4c5a6c00f3ba22294b0b22cf95bbbe2bd339a3b7b6ae05dee19738e63eb" => :yosemite
    sha256 "22f8d1ef9bb9cb989ca02e035b2f466524f10610d5d12a8d1fb9dd62eefab80f" => :mavericks
    sha256 "ee380370279915cd118536747fe189131f0506f4d3a6879b4d65724155c752a6" => :mountain_lion
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
