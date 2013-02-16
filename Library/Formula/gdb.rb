require 'formula'

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
  homepage 'http://www.gnu.org/software/gdb/'
  url 'http://ftpmirror.gnu.org/gdb/gdb-7.6.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gdb/gdb-7.6.tar.bz2'
  sha1 'b64095579a20e011beeaa5b264fe23a9606ee40f'

  depends_on 'readline'
  if build.include? 'with-brewed-python'
    depends_on UniversalBrewedPython
  end

  option 'with-brewed-python', 'Use the Homebrew version of Python'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--with-system-readline"]

    if build.include? 'with-brewed-python'
      args << "--with-python=#{HOMEBREW_PREFIX}"
    else
      args << "--with-python=/usr"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end
end
