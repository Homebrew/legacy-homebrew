require 'formula'

class Cmake < Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz'
  md5 '209b7d1d04b2e00986538d74ba764fcf'
  homepage 'http://www.cmake.org/'

  def install
    # A framework-installed expat will be detected and mess things up.
    if File.exist? "/Library/Frameworks/expat.framework"
      opoo "/Library/Frameworks/expat.framework detected"
      puts <<-EOS.undent
        This will be picked up by Cmake's build system and likey cause the
        build to fail, trying to link to a 32-bit version of expat.
        You may need to move this file out of the way for this brew to work.
      EOS
    end

    if ENV['GREP_OPTIONS'] == "--color=always"
      opoo "GREP_OPTIONS is set to '--color=always'"
      puts <<-EOS.undent
        Having `GREP_OPTIONS` set this way causes Cmake builds to fail.
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
