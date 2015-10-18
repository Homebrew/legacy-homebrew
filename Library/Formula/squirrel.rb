class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.0.7%20stable/squirrel_3_0_7_stable.tar.gz"
  version "3.0.7"
  sha256 "c7c2548e2d2d74116303445118e197f585a3a5e6bde06fdfe668c05b1cb43fa2"

  bottle do
    cellar :any
    sha1 "24ac32cfb018ba9ed7a68b1fd7314de307e6b60e" => :yosemite
    sha1 "7a4e09d82eaf35d16962df098d9342c3f1a95b81" => :mavericks
    sha1 "8d3ec975ba7dde650f11985df813ce49daa6f830" => :mountain_lion
  end

  def install
    system "make"
    prefix.install %w[bin include lib]
    doc.install Dir["doc/*.pdf"]
    doc.install %w[etc samples]
    # See: https://github.com/Homebrew/homebrew/pull/9977
    (lib+"pkgconfig/libsquirrel.pc").write pc_file
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
