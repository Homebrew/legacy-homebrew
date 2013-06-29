require 'formula'

class Libwbxml < Formula
  homepage 'https://libwbxml.opensync.org/'
  url 'http://sourceforge.net/projects/libwbxml/files/libwbxml/0.11.2/libwbxml-0.11.2.tar.bz2'
  sha1 '0b4f526709cac75c4b261666950bd935dda9f0d4'

  option 'docs', 'Build the documentation with Doxygen and Graphviz'

  depends_on 'cmake' => :build
  depends_on 'wget' => :optional
  depends_on 'doxygen' if build.include? 'docs'
  depends_on 'graphviz' if build.include? 'docs'

  def install
    mkdir "build" do
      args = std_cmake_args + %w[..]
      args << '-DBUILD_DOCUMENTATION=ON' if build.include? 'docs'
      system "cmake", *args
      system "make install"
    end
  end
end
