require 'formula'

class Ape < Formula
  homepage 'http://www.ape-project.org/'
  url 'https://github.com/APE-Project/APE_Server/tarball/v1.1.0'
  sha1 'ffecd63073a2239a144d5222fd1cd56cda411903'

  def install
    system "./build.sh"
    system "make", "install", "prefix=#{prefix}"
  end
end
