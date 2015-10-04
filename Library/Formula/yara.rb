class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://github.com/plusvic/yara/"
  url "https://github.com/plusvic/yara/archive/v3.4.0.tar.gz"
  sha256 "528571ff721364229f34f6d1ff0eedc3cd5a2a75bb94727dc6578c6efe3d618b"
  head "https://github.com/plusvic/yara.git"

  bottle do
    cellar :any
    sha256 "06f30b9ee4bf08b75531d2bcbd868385f4900bd89338cb76c1a3b893439924bf" => :el_capitan
    sha256 "464eb3be9b5d1ca097e3c8bd85820fd3d8ad6089a8043f82b2e933f0eccca01d" => :yosemite
    sha256 "85229abc8299bb2946949e4db5acde29a007fc53dae7b7ee38d2df7cfbad6ed2" => :mavericks
    sha256 "b0b6a9ae09e1e42e5a173a2e2589271c9d9ef4038a7165ecd6fa9ce9dd6c73a6" => :mountain_lion
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pcre"
  depends_on "openssl"

  # fixes a variable redefinition error with clang
  patch do
    url "https://github.com/plusvic/yara/pull/261.diff"
    sha256 "6b5c135b577a71ca1c1a5f0a15e512f5157b13dfbd08710f9679fb4cd0b47dba"
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

    cd "yara-python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end
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
