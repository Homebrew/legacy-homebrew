require 'formula'

class Ape < Formula
  homepage 'http://www.ape-project.org/'
  url 'https://github.com/APE-Project/APE_Server/archive/v1.1.2.tar.gz'
  sha1 'a2710108c0130fb4c00777ddde238f68aa4bc0e3'

  fails_with :clang do
    build 500
    cause 'multiple configure and compile errors'
  end

  def install
    system "./build.sh"
    system "make", "install", "prefix=#{prefix}"
  end
end
