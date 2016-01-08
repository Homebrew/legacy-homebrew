class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.0.7%20stable/squirrel_3_0_7_stable.tar.gz"
  version "3.0.7"
  sha256 "c7c2548e2d2d74116303445118e197f585a3a5e6bde06fdfe668c05b1cb43fa2"

  bottle do
    cellar :any
    sha256 "25e35b7af1a94e1c7495751dbb7be829774411cd05727c6745c668c5188ef8f2" => :yosemite
    sha256 "f20d4132e3913e8f62f459375ede7765f416f6b9756c935253f06f65b8d4a172" => :mavericks
    sha256 "1d077d71f76fe8b9bbb5ddc70654e5de4fed72b12ecbf35764bdd6e4396cd31e" => :mountain_lion
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
