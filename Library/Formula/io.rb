require "formula"

class Io < Formula
  homepage "http://iolanguage.com/"
  url "https://github.com/stevedekorte/io/archive/2013.12.04.tar.gz"
  sha1 "47d9a3e7a8e14c9fbe3b376e4967bb55f6c68aed"

  head "https://github.com/stevedekorte/io.git"

  option "without-addons", "Build without addons"

  depends_on "cmake" => :build

  if build.with? "addons"
    depends_on "glib"
    depends_on "cairo"
    depends_on "gmp"
    depends_on "jpeg"
    depends_on "libevent"
    depends_on "libffi"
    depends_on "libogg"
    depends_on "libpng"
    depends_on "libsndfile"
    depends_on "libtiff"
    depends_on "libvorbis"
    depends_on "ossp-uuid"
    depends_on "pcre"
    depends_on "yajl"
    depends_on "xz"
    depends_on :python => :optional
  end

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      make never completes. see:
      https://github.com/stevedekorte/io/issues/223
    EOS
  end

  # Fixes build on GCC with recursive inline functions;
  # committed upstream, will be in the next release.
  patch do
    url "https://github.com/stevedekorte/io/commit/f21a10ca0e8959e2a0774962c36392cf166be6a6.diff"
    sha1 "f8756e85268211e93dfd06a0eeade63bfb9bcc9c"
  end

  def install
    ENV.j1

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags '-fobjc-exceptions'

    if build.without? "addons"
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                  '#add_subdirectory(addons)'
    else
      inreplace "addons/CMakeLists.txt" do |s|
        if build.without? "python"
          s.gsub! "add_subdirectory(Python)", '#add_subdirectory(Python)'
        end

        # Turn off specific add-ons that are not currently working

        # Looks for deprecated Freetype header
        s.gsub! /(add_subdirectory\(Font\))/, '#\1'
        # Builds against older version of memcached library
        s.gsub! /(add_subdirectory\(Memcached\))/, '#\1'
      end
    end

    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make"
      output = %x[./_build/binaries/io ../libs/iovm/tests/correctness/run.io]
      if $?.exitstatus != 0
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
      system "make install"
    end
  end
end
