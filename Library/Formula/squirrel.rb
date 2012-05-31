require 'formula'

class Squirrel < Formula
  homepage 'http://www.squirrel-lang.org'
  url 'http://squirrel.googlecode.com/files/squirrel_3_0_2_stable.tar.gz'
  version '3.0.2'
  md5 '1355ee4220b0448119b6887719bae37f'

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
