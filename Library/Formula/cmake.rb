require 'formula'

class Cmake < Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.7.tar.gz'
  md5 'e1b237aeaed880f65dec9c20602452f6'
  homepage 'http://www.cmake.org/'

  bottle do
    url 'https://downloads.sf.net/project/machomebrew/Bottles/cmake-2.8.7-bottle.tar.gz'
    sha1 'f218ed64ce6e7a5d3670acdd6a18e5ed95421d1f'
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
