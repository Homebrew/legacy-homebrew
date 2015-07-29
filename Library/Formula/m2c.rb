class M2c < Formula
  desc "Modula-2 to C compiler"
  homepage "https://savannah.nongnu.org/projects/m2c/"
  url "http://download.savannah.gnu.org/releases/m2c/0.7/m2c-0.7.tar.gz"
  sha256 "b725ed617f376e1a321e059bf1985098e950965d5edab161c6b24526f10a59bc"
  head "http://git.savannah.gnu.org/cgit/m2c.git"

  # Hacks purely for this 0.7 release. Git head already fixes installation glitches.
  # Will remove hacks on release of next version.
  def install
    # The config for "gcc" works for clang also.
    cp "config/generic-gcc.h", "config/generic-clang.h"
    system "./configure", "+cc=#{ENV.cc}"

    # Makefile is buggy!
    inreplace "Makefile", "install: all uninstall", "install: all"
    inreplace "Makefile", "mkdir", "mkdir -p"
    include.mkpath

    system "make", "install", "prefix=#{prefix}", "man1dir=#{man1}"
  end

  test do
    hello_mod = "Hello.mod"
    hello_exe = testpath/"Hello"

    (testpath/hello_mod).write <<-EOF.undent
      MODULE Hello;

      FROM InOut IMPORT
        WriteLn, WriteString;

      BEGIN
        WriteString ("Hello world!");
        WriteLn;
      END Hello.
    EOF

    system "#{bin}/m2c", "-make", hello_mod, "-o", hello_exe

    assert_equal "Hello world!\n", shell_output(hello_exe)
  end
end
