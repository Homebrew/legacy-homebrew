require "formula"

class Yara < Formula
  homepage "https://github.com/plusvic/yara/"
  url "https://github.com/plusvic/yara/archive/v3.2.0.tar.gz"
  sha1 "dd1a92b1469cd629f6cd368aec32f207375b125b"
  head "https://github.com/plusvic/yara.git"

  bottle do
    cellar :any
    sha1 "3f77c2481bf0bfbd4be617a06b98611d9595ca41" => :yosemite
    sha1 "19e0547d33cacea6807a515f7c42e65c3fc8d842" => :mavericks
    sha1 "11e14894b2c26b452884fc3cf73f5cc4ebc71fcc" => :mountain_lion
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"
  depends_on "openssl"

  def install
    # Use of "inline" requires gnu89 semantics
    ENV.append "CFLAGS", "-std=gnu89" if ENV.compiler == :clang

    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib} -lpcre"

    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<-EOS.undent
      rule chrout {
        meta:
          description = "Calls CBM KERNAL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
