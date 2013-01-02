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
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.10.1.tar.gz'
  sha1 'ff536d0592a0433ef3610f1861886712b99979a5'

  bottle do
    sha1 '1a43a9a7f05216c9dc2458bca6aaa80c4a6cfc5b' => :mountainlion
    sha1 '31856bbd662ca47c325761fc7040e43f9a635c64' => :lion
    sha1 'ff80d9bb064fcec2e268896ede95532f99c6cfb6' => :snowleopard
  end

  depends_on NoExpatFramework.new

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

  def test
    system "#{bin}/cmake", "-E", "echo", "testing"
  end
end
