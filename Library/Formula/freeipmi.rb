class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.1.tar.gz"
  sha256 "47985ab902a62e23aba60e30a9fba5190599eecbc107d442e8b948a220ed1252"

  bottle do
    sha256 "3899c06966a03f33c81bcc3e9c8bda0c97b3b2a76d4735aa5d2442aa327f83ea" => :el_capitan
    sha256 "03bf2f25261711adc97bbd49a448fd8c6377343bad7e64ae3f43f0f30eebd0ed" => :yosemite
    sha256 "f03eea84bc3c7e8548f29716ff181489f97eb8021ea1daff73dcf13b02b0f917" => :mavericks
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
