class UniversalBrewedPython < Requirement
  satisfy { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A build of GDB using a brewed Python was requested, but Python is not
    a universal build.

    GDB requires Python to be built as a universal binary or it will fail
    if attempting to debug a 32-bit binary on a 64-bit host.
    EOS
  end
end

class UniversalBrewedPython3 < Requirement
  satisfy { archs_for_command("python3").universal? }

  def message; <<-EOS.undent
    A build of GDB using a brewed Python3 was requested, but Python3 is not
    a universal build.

    GDB requires Python3 to be built as a universal binary or it will fail
    if attempting to debug a 32-bit binary on a 64-bit host.
    EOS
  end
end

class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "http://ftpmirror.gnu.org/gdb/gdb-7.11.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.xz"
  sha256 "7a434116cb630d77bb40776e8f5d3937bed11dea56bafebb4d2bc5dd389fe5c1"

  bottle do
    sha256 "2714b84c6f290c5283410aa320bd5e49f76d9fbf976c1411ef2064995db1ee40" => :el_capitan
    sha256 "abf5752e3b3dcf2ca63ed56075f40c26829eed163f9e8687b74babfdf86483bd" => :yosemite
    sha256 "a4914821731b5cf229efcb061a4866a1a111590093334778f772fa6a9f9444c4" => :mavericks
  end

  deprecated_option "with-brewed-python" => "with-python"

  option "with-python3", "Use the Homebrew version of Python3"
  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "guile" => :optional

  if build.with? "python"
    depends_on UniversalBrewedPython
  end

  if build.with? "python3"
    depends_on UniversalBrewedPython3
    patch :p1, :DATA
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-lzma",
    ]

    args << "--with-guile" if build.with? "guile"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with? "python"
      args << "--with-python=#{HOMEBREW_PREFIX}"
    elsif build.with? "python3"
      args << "--with-python=#{HOMEBREW_PREFIX}/bin/python3"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Remove conflicting items with binutils
    rm_rf include
    rm_rf lib
    rm_rf share/"locale"
    rm_rf share/"info"
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      https://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
__END__
diff --git a/gdb/python/python-config.py b/gdb/python/python-config
--- a/gdb/python/python-config.py	2015-12-18 22:46:55.000000000 +0800
+++ b/gdb/python/python-config.py	2015-12-18 22:47:22.000000000 +0800
@@ -72,7 +72,5 @@
                     libs.insert(0, '-L' + getvar('LIBPL'))
                 elif os.name == 'nt':
                     libs.insert(0, '-L' + sysconfig.PREFIX + '/libs')
-            if getvar('LINKFORSHARED') is not None:
-                libs.extend(getvar('LINKFORSHARED').split())
         print (to_unix_path(' '.join(libs)))
