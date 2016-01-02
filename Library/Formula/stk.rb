class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.5.0.tar.gz"
  sha256 "619f1a0dee852bb2b2f37730e2632d83b7e0e3ea13b4e8a3166bf11191956ee3"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8d8b488cd816e06005998c7ecf1d76a1fee75698a567073d0dc654ce64b51647" => :el_capitan
    sha256 "3549b42faa4640d337110a5f5a44841790b1764cee11acb2145ffa638b3570a2" => :yosemite
    sha256 "b1195d0437e7ab54130a2c49aaf2ab77f4b587b08e0bbb4513c1898f4db0c010" => :mavericks
  end

  option "with-debug", "Compile with debug flags and modified CFLAGS for easier debugging"

  deprecated_option "enable-debug" => "with-debug"

  fails_with :clang do
    build 421
    cause "due to configure file this application will not properly compile with clang"
  end

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "debug"
      inreplace "configure", 'CFLAGS="-g -O2"', 'CFLAGS="-g -O0"'
      inreplace "configure", 'CXXFLAGS="-g -O2"', 'CXXFLAGS="-g -O0"'
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS $cppflag"', ' CPPFLAGS="$CPPFLAGS $cppflag -g -O0"'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats; <<-EOS.undent
    The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

      #include \"stk/FileLoop.h\"
      #include \"stk/FileWvOut.h\"

    src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end
end
