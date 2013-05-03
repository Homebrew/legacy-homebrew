require 'formula'

class Ape < Formula
  homepage 'http://www.ape-project.org/'
  url 'https://github.com/APE-Project/APE_Server/archive/v1.1.0.tar.gz'
  sha1 '5543822a0455f59ae249a85740d8d040bb8c03cf'

  fails_with :clang do
    build 425
    cause 'multiple configure and compile errors'
  end

  def install
    system "./build.sh"
    system "make", "install", "prefix=#{prefix}"
  end
end
