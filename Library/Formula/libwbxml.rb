require 'formula'

class Libwbxml < Formula
  url 'http://sourceforge.net/projects/libwbxml/files/libwbxml/0.10.8/libwbxml-0.10.8.tar.gz'
  homepage 'https://libwbxml.opensync.org/'
  sha1 '7704cdf5952ff6916158bbc76aa919ceb1780957'

  depends_on 'cmake' => :build

  def install
    mkdir "build"
    Dir.chdir "build" do
      system "cmake ../ #{std_cmake_parameters}"
      system "make install"
    end
  end
end
