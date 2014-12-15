require 'formula'

class Squirrel < Formula
  homepage 'http://www.squirrel-lang.org'
  url 'http://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.0.6%20stable/squirrel_3_0_6_stable.tar.gz'
  version '3.0.6'
  sha256 '9e30e5d86ff59ffad32df46ae4e0f114a086fd03ef337984f3c30d8f41f97afc'

  def install
    # -s causes the linker to crash
    inreplace "sq/Makefile", " -s ", " "
    system "make"
    prefix.install %w[bin include lib]
    doc.install Dir['doc/*.pdf']
    doc.install %w[etc samples]
    # See: https://github.com/Homebrew/homebrew/pull/9977
    (lib+'pkgconfig/libsquirrel.pc').write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=/${exec_prefix}/lib
    includedir=/${prefix}/include
    bindir=/${prefix}/bin
    ldflags=  -L/${prefix}/lib

    Name: libsquirrel
    Description: squirrel library
    Version: #{version}

    Requires:
    Libs: -L${libdir} -lsquirrel -lsqstdlib
    Cflags: -I${includedir}
    EOS
  end
end
