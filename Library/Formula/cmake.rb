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
  url 'http://www.cmake.org/files/v3.0/cmake-3.0.0.tar.gz'
  sha1 '4dfd9ee9b829c77175d655f22322f14747f11ad2'

  head 'http://cmake.org/cmake.git'

  bottle do
    cellar :any
    sha1 "1055d958bee856c8ab919a2f89a167487a82becb" => :mavericks
    sha1 "dc2ccbc4f63b809d1088cfd91573689cb571e6f9" => :mountain_lion
    sha1 "4ba0618795f9655aa8a937ec9e02378578b64bc9" => :lion
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
