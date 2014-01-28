require 'formula'

class NoExpatFramework < Requirement
  def expat_framework
    '/Library/Frameworks/expat.framework'
  end

  satisfy :build_env => false do
    not File.exist? expat_framework
  end

  def message; <<-EOS.undent
    Detected #{expat_framework}

    This will be picked up by CMake's build system and likely cause the
    build to fail, trying to link to a 32-bit version of expat.

    You may need to move this file out of the way to compile CMake.
    EOS
  end
end

class Cmake < Formula
  homepage 'http://www.cmake.org/'
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.12.1.tar.gz'
  sha1 '5661a607acbce7c16bb5f15ff2895fa5ca53a4da'

  head 'http://cmake.org/cmake.git'

  bottle do
    cellar :any
    revision 1
    sha1 '6a4c11225de1e0f1184f2391dc6806a54ef07576' => :mavericks
    sha1 '4e3891ec5fec6fd5e8867c9225ba6997e81cabd3' => :mountain_lion
    sha1 '978a056dd68407bec5985e83e512dfc19adbabd8' => :lion
  end

  depends_on NoExpatFramework

  def install
    args = %W[
      --prefix=#{prefix}
      --system-libs
      --no-system-libarchive
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]

    system "./bootstrap", *args
    system "make"
    system "make install"
  end

  test do
    (testpath/'CMakeLists.txt').write('find_package(Ruby)')
    system "#{bin}/cmake", '.'
  end
end
