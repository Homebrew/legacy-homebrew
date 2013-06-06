require 'formula'

class Stk < Formula
  homepage 'https://ccrma.stanford.edu/software/stk/'
  url 'http://ccrma.stanford.edu/software/stk/release/stk-4.4.4.tar.gz'
  sha1 '2a94f02ed054d3b991352cc68a85a0a8063e3a4b'

  depends_on :automake

  option "enable-debug", "Compile with debug flags and modified CFLAGS for easier debugging"

  fails_with :clang do
    build 421
    cause 'due to configure file this application will not properly compile with clang'
  end

  def install

    if build.include? "enable-debug"
      inreplace 'configure', 'CFLAGS="-g -O2"', 'CFLAGS="-g -O0"'
      inreplace 'configure', 'CXXFLAGS="-g -O2"', 'CXXFLAGS="-g -O0"'
      inreplace 'configure', 'CPPFLAGS="$CPPFLAGS $cppflag"',' CPPFLAGS="$CPPFLAGS $cppflag -g -O0"'
      debug_status = "--enable-debug"
    else
      debug_status = "--disable-debug"
    end

    system "./configure", "--prefix=#{prefix}",
                          debug_status,
                          "--disable-dependency-tracking"

    system "make"

    lib.install 'src/libstk.a'
    bin.install 'bin/treesed'

    (include/'stk').install Dir['include/*']
    doc.install Dir['doc/*']
    (share/'stk').install 'src', 'projects', 'rawwaves'
  end

  def caveats; <<-EOS.undent
    The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

      #include \"stk/FileLoop.h\"
      #include \"stk/FileWvOut.h\"

    src/ projects/ and rawwaves/ have all been copied to /usr/local/share/stk
    EOS
  end
end
