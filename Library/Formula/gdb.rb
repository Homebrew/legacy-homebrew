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
  url "http://ftpmirror.gnu.org/gdb/gdb-7.9.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-7.9.tar.xz"
  sha256 "9b315651a16528f7af8c7d8284699fb0c965df316cc7339bb0b7bae335848392"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-dupes"
    sha256 "10e88bdde65a5d16c9a6c755d44a95589b29f3b1a6709164afec0999d12c4db3" => :yosemite
    sha256 "6255b9804cb274c6a25a876f3931e72933e73d087d018e76f606890b1f2ffb2b" => :mavericks
    sha256 "d41dc2e5bda369f8b5017b9c1a20541b248d7a669fec54d43ccf45695e21bd4c" => :mountain_lion
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
      "--with-lzma",
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
