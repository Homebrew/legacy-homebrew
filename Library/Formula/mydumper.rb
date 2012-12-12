require 'formula'

class Mydumper < Formula
  homepage 'http://www.mydumper.org/'
  url 'http://launchpadlibrarian.net/77098505/mydumper-0.5.1.tar.gz'
  sha1 '75635b9c25ca878bfe7907efd136aa4229161d72'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on :mysql
  depends_on 'glib'
  depends_on 'pcre'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/mydumper", "--version"
  end
end
