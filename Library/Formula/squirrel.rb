require 'formula'

class Squirrel < Formula
  homepage 'http://www.squirrel-lang.org'
  url 'https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.0.6%20stable/squirrel_3_0_6_stable.tar.gz'
  version '3.0.6'
  sha1 'b4ab6055f8cd8997df54193ac92bd3dc041f054b'

  bottle do
    cellar :any
    sha1 "306d52e2b2bb99df7b9622a4bfcb31e0585a3618" => :yosemite
    sha1 "232448b9e82a130d9717d8e1119a5fd24e2801e1" => :mavericks
    sha1 "e473092003e6e71b7c15adaf1dcbfe9ea258bc98" => :mountain_lion
  end

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
