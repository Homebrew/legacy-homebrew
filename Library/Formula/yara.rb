class Yara < Formula
  homepage "https://github.com/plusvic/yara/"
  url "https://github.com/plusvic/yara/archive/v3.3.0.tar.gz"
  sha1 "6f72d80f21336c098f9013212d496d3920d9ef18"
  head "https://github.com/plusvic/yara.git"

  bottle do
    cellar :any
    sha1 "75e874c69b0a326e200ec289fd7fd3bdb2d5c146" => :yosemite
    sha1 "0459df8e18781fdaf365bb54d62b28585e36cda2" => :mavericks
    sha1 "4b39059db000f82d8dde03b99db89354761e3c6a" => :mountain_lion
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"
  depends_on "openssl"

  # fixes a variable redefinition error with clang
  patch do
    url "https://github.com/plusvic/yara/pull/261.diff"
    sha1 "17ed1efbd2c4575109bb7b7e2f0c883795dc3163"
  end

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
