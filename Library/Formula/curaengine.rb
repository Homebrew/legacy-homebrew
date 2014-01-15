require 'formula'

class Curaengine < Formula
  homepage 'https://github.com/Ultimaker/CuraEngine'
  head 'https://github.com/Ultimaker/CuraEngine.git'
  url 'https://github.com/Ultimaker/CuraEngine/archive/14.01.tar.gz'
  sha1 '015096620c885eb25da6fd7be672de25717d45c1'

  def install
    ENV.deparallelize
    system "make"
    bin.install 'CuraEngine'
  end
end
