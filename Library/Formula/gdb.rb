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

class Gdb < Formula
  homepage "https://www.gnu.org/software/gdb/"
  url "http://ftpmirror.gnu.org/gdb/gdb-7.10.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-7.10.tar.xz"
  sha256 "7ebdaa44f9786ce0c142da4e36797d2020c55fa091905ac5af1846b5756208a8"

  bottle do
    sha256 "61fb08af16a19575c8b0e2b85ca2cbb59ddd1a81e914927b9be64a63fb6df0db" => :yosemite
    sha256 "3ad006cd86d38ae0d2e59eb896f26f2afe924fb973884bad01589baf178841ab" => :mavericks
    sha256 "c19cb81fca3468032e1979c96c3d7ec796af32f96abb6843980fc1621b89db37" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "xz"
  depends_on "guile" => :optional

  if build.with? "brewed-python"
    depends_on UniversalBrewedPython
  end

  option "with-brewed-python", "Use the Homebrew version of Python"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-system-readline",
      "--with-lzma"
    ]

    args << "--with-guile" if build.with? "guile"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with? "brewed-python"
      args << "--with-python=#{HOMEBREW_PREFIX}"
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

      http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end
end
