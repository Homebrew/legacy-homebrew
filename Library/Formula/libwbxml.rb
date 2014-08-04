require 'formula'

class Libwbxml < Formula
  homepage 'https://libwbxml.opensync.org/'
  url 'https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.2/libwbxml-0.11.2.tar.bz2'
  sha1 '0b4f526709cac75c4b261666950bd935dda9f0d4'

  bottle do
    cellar :any
    sha1 "a44c7354e3cb619d058e1325682ade17e753cf8f" => :mavericks
    sha1 "fc6672f54bba9f56c374add1f211dcf9dcc01d4e" => :mountain_lion
    sha1 "d822c01d56c4268913850b677ff4aedd4ba51cd7" => :lion
  end

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
