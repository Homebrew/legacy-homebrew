require 'formula'

class GambitScheme < Formula
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.7/source/gambc-v4_7_0.tgz'
  sha256 '2b03ecef89da2a53212dc3e6583ee4175d91a0752779e1758bcab5d09e9d1e63'

  option 'with-check', 'Execute "make check" before installing'
  option 'enable-shared', 'Build Gambit Scheme runtime as shared library'

  fails_with :llvm

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --libdir=#{lib}/gambit-c
      --infodir=#{info}
      --docdir=#{doc}
    ]

    # Recommended to improve the execution speed and compactness
    # of the generated executables. Increases compilation times.
    # Don't enable this when using clang, per configure warning.
    args << "--enable-single-host" unless ENV.compiler == :clang

    args << "--enable-shared" if build.include? 'enable-shared'

    if ENV.compiler == :clang
      opoo <<-EOS.undent
        Gambit will build with Clang, however the build may take longer and
        produce substandard binaries. If you have GCC, you can get a faster
        build and faster execution with:
          brew install gambit-scheme --cc=gcc-4.2 # or 4.7, 4.8, etc.
      EOS
    end

    system "./configure", *args
    system "make check" if build.include? 'with-check'

    ENV.j1
    system "make"
    system "make install"
  end
end
