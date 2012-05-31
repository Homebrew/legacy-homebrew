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
    version 1
    sha1 'e1251ca112398348b1a150600826fc2befb200dd' => :lion
    sha1 '51d960d0ebff661babd23970f69e9fcaaac9b1f3' => :snowleopard
  end

  depends_on NoExpatFramework.new

  # Correct FindPkgConfig found variable. Remove for CMake 2.8.9.
  def patches
    "https://github.com/Kitware/CMake/commit/3ea850.patch"
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
