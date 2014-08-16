require "formula"

class Freeipmi < Formula
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.4.5.tar.gz"
  sha1 "21f567f452de53545a8880eaf572cad567e5ad30"

  bottle do
    sha1 "7cf899745d7735a839980d3318e24bccd29b0783" => :mavericks
    sha1 "0b9e80a42979483e33609ff2420d11798f2a4ffd" => :mountain_lion
    sha1 "097c738d84aa241b5c75575dbc8f320496794aaf" => :lion
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
