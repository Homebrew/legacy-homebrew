class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "http://ccrma.stanford.edu/software/stk/release/stk-4.5.0.tar.gz"
  sha256 "619f1a0dee852bb2b2f37730e2632d83b7e0e3ea13b4e8a3166bf11191956ee3"

  bottle do
    sha256 "0574da516da74a8f48d54e945fcaa67201de4f77ac0842d76cb642677fa86d95" => :mavericks
    sha256 "3d7b94dff2b2b4b5620ed8fa4087720f4ccbf7a83c5f68325a50d0cbb641b62f" => :mountain_lion
    sha256 "377f662ab8c73979f8aeed28e75bc3884f1840a7e6dc82bb48855dd89fb4a8dc" => :lion
  end

  option "enable-debug", "Compile with debug flags and modified CFLAGS for easier debugging"

  fails_with :clang do
    build 421
    cause "due to configure file this application will not properly compile with clang"
  end

  def install
    if build.include? "enable-debug"
      inreplace "configure", 'CFLAGS="-g -O2"', 'CFLAGS="-g -O0"'
      inreplace "configure", 'CXXFLAGS="-g -O2"', 'CXXFLAGS="-g -O0"'
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS $cppflag"', ' CPPFLAGS="$CPPFLAGS $cppflag -g -O0"'
      debug_status = "--enable-debug"
    else
      debug_status = "--disable-debug"
    end

    system "./configure", "--prefix=#{prefix}",
                          debug_status,
                          "--disable-dependency-tracking"

    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    (share/"stk").install "src", "projects", "rawwaves"
  end

  def caveats; <<-EOS.undent
    The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

      #include \"stk/FileLoop.h\"
      #include \"stk/FileWvOut.h\"

    src/ projects/ and rawwaves/ have all been copied to /usr/local/share/stk
    EOS
  end
end
