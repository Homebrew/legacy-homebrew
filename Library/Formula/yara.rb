require 'formula'

class Yara < Formula
  homepage 'https://github.com/plusvic/yara/'
  url 'https://github.com/plusvic/yara/archive/v3.0.0.tar.gz'
  sha1 '43e7e0df03043cab1ab8299ef7ebee4d2c5d39dc'

  depends_on 'pcre'
  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install
    # Use of 'inline' requires gnu89 semantics
    ENV.append 'CFLAGS', '-std=gnu89' if ENV.compiler == :clang

    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{Formula["pcre"].opt_lib} -lpcre"

    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
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
