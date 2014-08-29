require 'formula'

class GambitScheme < Formula
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.7/source/gambc-v4_7_2.tgz'
  sha256 'c09597fa423602eb9d06b1ab3c1a63cd9c612b89f7f6d718f2c0a96da4d4ac1a'

  bottle do
    sha1 "e91aa45c23c225c024c0d013ec37150ac57a3777" => :mavericks
    sha1 "a8d9d58347d1e67317a2276a5c33415c2d4717f6" => :mountain_lion
    sha1 "da656ff450a9bb435a81b8d317cb3409540a8668" => :lion
  end

  conflicts_with 'ghostscript', :because => 'both install `gsc` binaries'
  conflicts_with 'scheme48', :because => 'both install `scheme-r5rs` binaries'

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
    system "make check" if build.with? "check"

    ENV.j1
    system "make"
    system "make install"
  end
end
