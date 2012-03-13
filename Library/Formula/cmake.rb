require 'formula'

class Cmake < Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.7.tar.gz'
  md5 'e1b237aeaed880f65dec9c20602452f6'
  homepage 'http://www.cmake.org/'

  # Fix issues with Xcode 4.3. Remove for 2.8.8.
  def patches
    [ 'https://github.com/Kitware/CMake/commit/5663e.patch',
      'https://github.com/Kitware/CMake/commit/4693c.patch' ]
  end

  bottle do
    url 'https://downloads.sf.net/project/machomebrew/Bottles/cmake-2.8.7-bottle.tar.gz'
    sha1 '3a57f6f44186e0dba34ef8b8fb4a9047e9e5d8a3'
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
