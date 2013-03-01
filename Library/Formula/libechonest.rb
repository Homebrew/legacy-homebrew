require 'formula'

class Libechonest < Formula
  homepage 'https://projects.kde.org/projects/playground/libs/libechonest'
  url 'http://files.lfranchi.com/libechonest-2.0.3.tar.bz2'
  sha1 '10ada8aced6dce3c0d206afcfbd4b05313bd4d04'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'qjson'

  conflicts_with 'doxygen', :because => "cmake fails to configure build."

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
