require 'formula'

class Cmake < Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.5.tar.gz'
  md5 '3c5d32cec0f4c2dc45f4c2e84f4a20c5'
  homepage 'http://www.cmake.org/'
  bottle 'https://downloads.sf.net/project/machomebrew/Bottles/cmake-2.8.5-bottle.tar.gz'
  bottle_sha1 'f7a4c459625eb9282fef9789cab2a702a2dff06a'

  def patches
    # CMake 2.8.5 fails to find some Qt libraries that CMake 2.8.4 could find.
    # The following patch corrects this behavior. See discussion on the CMake
    # mailing list:
    #
    #   http://cmake.3232098.n2.nabble.com/FindQt4-errors-out-when-locating-QtUITools-under-CMake-2-8-5-td6619091.html
    #
    # Patch can be removed after next CMake release.
    {:p1 => "http://cmake.org/gitweb?p=cmake.git;a=patch;h=702538eaa3315f3fcad9f1daea01e6a83928967b"}
  end

  def install
    # A framework-installed expat will be detected and mess things up.
    if File.exist? "/Library/Frameworks/expat.framework"
      opoo "/Library/Frameworks/expat.framework detected"
      puts <<-EOS.undent
        This will be picked up by CMake's build system and likey cause the
        build to fail, trying to link to a 32-bit version of expat.
        You may need to move this file out of the way for this brew to work.
      EOS
    end

    if ENV['GREP_OPTIONS'] == "--color=always"
      opoo "GREP_OPTIONS is set to '--color=always'"
      puts <<-EOS.undent
        Having `GREP_OPTIONS` set this way causes CMake builds to fail.
        You will need to `unset GREP_OPTIONS` before brewing.
      EOS
    end

    system "./bootstrap", "--prefix=#{prefix}",
                          "--system-libs",
                          "--no-system-libarchive",
                          "--datadir=/share/cmake",
                          "--docdir=/share/doc/cmake",
                          "--mandir=/share/man"
    system "make"
    system "make install"
  end
end
