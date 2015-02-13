require 'formula'

class Squirrel < Formula
  homepage 'http://www.squirrel-lang.org'
  url 'https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.0.7%20stable/squirrel_3_0_7_stable.tar.gz'
  version '3.0.7'
  sha1 '5ae3f669677ac5f5d663ec070d42ee68980e1911'

  bottle do
    cellar :any
    sha1 "306d52e2b2bb99df7b9622a4bfcb31e0585a3618" => :yosemite
    sha1 "232448b9e82a130d9717d8e1119a5fd24e2801e1" => :mavericks
    sha1 "e473092003e6e71b7c15adaf1dcbfe9ea258bc98" => :mountain_lion
  end

  def install
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
