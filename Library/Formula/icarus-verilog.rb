require 'formula'

class IcarusVerilog < Formula
  homepage 'http://iverilog.icarus.com/'
  url 'ftp://icarus.com/pub/eda/verilog/v0.9/verilog-0.9.5.tar.gz'
  sha1 '3a69cb935ab562882a07a52904f3cba74aed2229'
  head 'git://github.com/steveicarus/iverilog.git'

  devel do
    url 'ftp://ftp.icarus.com/pub/eda/verilog/snapshots/verilog-20120501.tar.gz'
    sha1 '313ab0f5dc4d198bd4687daaf2e54749c67558b3'
  end

  # Yes indeed, this software fails to compile out of the box with both
  # LLVM and Clang.
  
  fails_with :llvm do
    build '2336'
    cause <<-EOS.undent
      ld: warning: unexpected dylib (/usr/lib/libSystem.dylib) on link line
      Assertion failed: (_machoSection != 0), function machoSection, file /SourceCache/ld64/ld64-128.2/src/ld/ld.hpp, line 565.
    EOS
  end

  fails_with :clang do
    build '318'
    cause <<-EOS.undent
      ld: warning: unexpected dylib (/usr/lib/libSystem.dylib) on link line
      Assertion failed: (_machoSection != 0), function machoSection, file /SourceCache/ld64/ld64-128.2/src/ld/ld.hpp, line 565.
    EOS
  end

  def install
<<<<<<< HEAD
=======
    # ENV Vars were causing build errors
    # So we clear them out
    ENV['CC'] = "gcc"
    ENV['CXX'] = "g++"
    ENV['LD'] = "ld"
    ENV['OBJC']="gcc"
    ENV['CFLAGS'] =  "-fnested-functions"
    ENV['CPPFLAGS']=""
    ENV['CXXFLAGS']=""

    system "sh autoconf.sh"
>>>>>>> 5a39686... Removed ENV vars causing icarus-verilog recipe not to build on Mountain Lion
    system "./configure", "--prefix=#{prefix}"
    system "make check"
    # Separate steps, as install does not depend on compile properly
    system "make"
    system "make installdirs"
    system "make install"
  end
end
