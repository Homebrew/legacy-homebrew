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
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz'
  sha1 'cca70b307aa32a6a32c72e01fdfcecc84c1c2690'

  head 'http://cmake.org/cmake.git'

  bottle do
    cellar :any
    revision 2
    sha1 "e1e50cfd9f421b64365a7a2c34e9e6337f9391b7" => :mavericks
    sha1 "9c60ed323f8752eb257d1505e33d70e4367e4219" => :mountain_lion
    sha1 "1914f68373cdc8d1c99b4d76e1e1fed85e4303d3" => :lion
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
