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
  homepage 'http://www.cmake.org/'
<<<<<<< HEAD
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.8.tar.gz'
  sha1 'a74dfc3e0a0d7f857ac5dda03bb99ebf07676da1'

  bottle do
    version 3
    sha1 '64e1a488bc669f7676c99874b8496ac147d1bc70' => :mountainlion
    sha1 'bdfb5fcd6743d65f6cfe00b314f9d3f1049e902b' => :lion
    sha1 '3a77fc17a7b1d3cceabddcca5c126c6b911c2f90' => :snowleopard
=======
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.9.tar.gz'
  sha1 'b96663c0757a5edfbddc410aabf7126a92131e2b'

  bottle do
    sha1 'ae7e0cf39556ea0a32e7bb7716ac820734ca7918' => :mountainlion
    sha1 '6631aaeeafb9209e711508ad72727fbb4b5ab295' => :lion
    sha1 'ea52f2a18b00f3404e8bf73c12c3da1d9a39f128' => :snowleopard
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  end

  depends_on NoExpatFramework.new

<<<<<<< HEAD
  def options
    [["--enable-ninja", "Enable Ninja build system support"]]
  end

  def patches
    [
      # Correct FindPkgConfig found variable. Remove for CMake 2.8.9.
      "https://github.com/Kitware/CMake/commit/3ea850.patch",
      # Workaround DeployQt4 issue. Remove for CMake 2.8.9.
      "https://github.com/Kitware/CMake/commit/374b9b.patch",
      # Protect the default value of CMAKE_FIND_FRAMEWORK so that it can be
      # overridden from the command line. Remove for CMake 2.8.9.
      "https://github.com/Kitware/CMake/commit/8b2fb3.patch"
=======
  def install
    args = %W[
      --prefix=#{prefix}
      --system-libs
      --no-system-libarchive
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    ]

<<<<<<< HEAD
  def install
    args = %W[
      --prefix=#{prefix}
      --system-libs
      --no-system-libarchive
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]

    if ARGV.include? "--enable-ninja"
      args << "--"
      args << "-DCMAKE_ENABLE_NINJA=1"
    end

=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    system "./bootstrap", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/cmake", "-E", "echo", "testing"
  end
end
