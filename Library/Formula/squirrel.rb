require 'formula'

class Squirrel < Formula
  homepage 'http://www.squirrel-lang.org'
  url 'http://squirrel.googlecode.com/files/squirrel_3_0_4_stable.tar.gz'
  version '3.0.4'
  sha1 '384d278630040902bc111d8b9fb607d4d4941904'

  def install
    system "make"

    prefix.install %w[bin include lib]
    doc.install Dir['doc/*.pdf']
    doc.install %w[etc samples]
    # See: https://github.com/mxcl/homebrew/pull/9977
    (lib+'pkgconfig/libsquirrel.pc').write pkg_file
  end

  def pkg_file; <<-EOS.undent
    prefix=#{prefix}
    exec_prefix=${prefix}
    libdir=/${exec_prefix}/lib
    includedir=/${prefix}/include
    bindir=/${prefix}/bin
    ldflags=  -L/${prefix}/lib

    Name: libsquirrel
    Description: squirrel library
    Version: 3.0.2

    Requires:
    Libs: -L${libdir} -lsquirrel -lsqstdlib
    Cflags: -I${includedir}
    EOS
  end
end
