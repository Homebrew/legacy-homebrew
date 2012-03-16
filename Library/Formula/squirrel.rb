require 'formula'

class Squirrel < Formula
  url 'http://squirrel.googlecode.com/files/squirrel_3_0_2_stable.tar.gz'
  homepage 'http://www.squirrel-lang.org'
  md5 '1355ee4220b0448119b6887719bae37f'

  def install
    system "make"

    prefix.install %w[bin include lib]
    doc.install Dir['doc/*.pdf']
    doc.install %w[etc samples]
    (lib+'pkgconfig/libsquirrel.pc').write pkg_file
  end

  def pkg_file; <<-EOF
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
EOF
  end
end
