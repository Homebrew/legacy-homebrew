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
<<<<<<< HEAD
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
=======
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.10.2.tar.gz'
  sha1 '2d868ccc3f9f2aa7c2844bd0a4609d5313edaaec'

  bottle do
    sha1 '0bdd4bfd4a094d3fbacbe33d0968161a0f24d665' => :mountain_lion
    sha1 '340f321eed8fd6b423980ecf9bed90646fc9331c' => :lion
    sha1 'c23c8c6124c1d59817301678cabad9517966d899' => :snow_leopard
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
  end

  depends_on NoExpatFramework

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

  test do
    File.open('CMakeLists.txt', 'w') {|f| f.write('find_package(Ruby)') }
    system "#{bin}/cmake", '.'
  end
end
