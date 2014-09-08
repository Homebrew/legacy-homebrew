require 'formula'

class Squirrel < Formula
  homepage 'http://www.squirrel-lang.org'
  url 'https://squirrel.googlecode.com/files/squirrel_3_0_4_stable.tar.gz'
  version '3.0.4'
  sha1 '384d278630040902bc111d8b9fb607d4d4941904'

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
