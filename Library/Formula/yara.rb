require 'formula'

class Yara < Formula
  homepage 'https://github.com/plusvic/yara/'
  url 'https://github.com/plusvic/yara/archive/v2.1.0.tar.gz'
  sha1 '8289c281a44c933e11de25953f3910fe9f8ee82e'

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
    File.open(program, "wb") do |f|
      f.write [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")
    end

    out = `#{bin}/yara #{rules} #{program}`
    assert_equal "chrout #{program}\n", out
    assert_equal 0, $?.exitstatus
  end
end
