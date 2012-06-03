require 'formula'

class NoExpatFramework < Requirement
  def message; <<-EOS.undent
    Detected /Library/Frameworks/expat.framework

    This will be picked up by CMake's build system and likely cause the
    build to fail, trying to link to a 32-bit version of expat.

    You may need to move this file out of the way to compile CMake.
    EOS
  end
  def satisfied?
    not File.exist? "/Library/Frameworks/expat.framework"
  end
end


class Cmake < Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.8.tar.gz'
  md5 'ba74b22c788a0c8547976b880cd02b17'
  homepage 'http://www.cmake.org/'

  bottle do
    version 2
    sha1 '64de3916cea46cf98ff0853db401109394cfbd5d' => :lion
    sha1 'da25300b55944c84e6a0c2e4efc57bb160a02806' => :snowleopard
  end

  depends_on NoExpatFramework.new

  def patches
    [
      # Correct FindPkgConfig found variable. Remove for CMake 2.8.9.
      "https://github.com/Kitware/CMake/commit/3ea850.patch",
      # Protect the default value of CMAKE_FIND_FRAMEWORK so that it can be
      # overridden from the command line. Remove for CMake 2.8.9.
      "https://github.com/Kitware/CMake/commit/8b2fb3.patch"
    ]
  end

  def install
    system "./bootstrap", "--prefix=#{prefix}",
                          "--system-libs",
                          "--no-system-libarchive",
                          "--datadir=/share/cmake",
                          "--docdir=/share/doc/cmake",
                          "--mandir=/share/man"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/cmake", "-E", "echo", "testing"
  end
end
