require 'formula'

class Curaengine < Formula
  homepage 'https://github.com/Ultimaker/CuraEngine'
  head 'https://github.com/Ultimaker/CuraEngine.git'
  url 'https://github.com/Ultimaker/CuraEngine/archive/13.11.2.tar.gz'
  sha1 '1a3e3933153421ac22c368ffca9b7ae192a2fc6a'

  def install
    ENV.deparallelize
    system "make"
    bin.install 'CuraEngine'
  end
end
