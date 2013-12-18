require 'formula'

class Io < Formula
  homepage 'http://iolanguage.com/'
  url 'https://github.com/stevedekorte/io/archive/2013.12.04.tar.gz'
  sha1 '47d9a3e7a8e14c9fbe3b376e4967bb55f6c68aed'

  head 'https://github.com/stevedekorte/io.git'

  option 'without-addons', 'Build without addons'

  depends_on 'cmake' => :build
  depends_on :python => :recommended
  depends_on 'libevent'
  depends_on 'libffi'
  depends_on 'ossp-uuid'
  depends_on 'pcre'
  depends_on 'yajl'
  depends_on 'xz'

  # Used by Bignum add-on
  depends_on 'gmp' unless build.include? 'without-addons'

  # Used by Fonts add-on
  depends_on :freetype unless build.include? 'without-addons'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      make never completes. see:
      https://github.com/stevedekorte/io/issues/223
    EOS
  end

  def install
    ENV.j1
    if build.without? 'addons'
      inreplace  "CMakeLists.txt",
        'add_subdirectory(addons)',
        '#add_subdirectory(addons)'
    end
    if build.without? 'python'
      inreplace  "addons/CMakeLists.txt",
        'add_subdirectory(Python)',
        '#add_subdirectory(Python)'
    end
    mkdir 'buildroot' do
      args = std_cmake_args
      # For Xcode-only systems, the headers of system's python are inside of Xcode:
      args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'" if python
      # Cmake picks up the system's python dylib, even if we have a brewed one:
      args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'" if python
      system "cmake", "..", *args
      system 'make'
      output = %x[./_build/binaries/io ../libs/iovm/tests/correctness/run.io]
      if $?.exitstatus != 0
        opoo "Test suite not 100% successful:\n#{output}"
      else
        ohai "Test suite ran successfully:\n#{output}"
      end
      system 'make install'
    end
  end
end
