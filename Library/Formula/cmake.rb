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
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.11.2.tar.gz'
  sha1 '31f217c9305add433e77eff49a6eac0047b9e929'

  head 'http://cmake.org/cmake.git'

  bottle do
    cellar :any
    sha1 '024d5263bce0f7f36bde4579ce6fc9be9d55fd72' => :mountain_lion
    sha1 'bfcc7c9925aea56bd5ce883ed8ca391c27144551' => :lion
    sha1 '22a1369e2ed4b4a4113621b9df6fd75b162e35fb' => :snow_leopard
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
