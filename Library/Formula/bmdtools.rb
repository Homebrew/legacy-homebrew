require 'formula'
 
class Bmdtools < Formula
  homepage 'http://github.com/lu-zero/bmdtools'
  url 'https://github.com/lu-zero/bmdtools/archive/v0.1.zip'
  sha256 'cc2a2f9c91b019dadea6dff591b07ceb7db05ce8c25ff405f715206ee81c7664'
  head 'https://github.com/lu-zero/bmdtools.git'
 
  env :std
 
  depends_on 'pkg-config' => :build
  depends_on 'decklinksdk' => :build
  depends_on 'libav' => :build
 
  def install
     system "make", "SDK_PATH=/usr/local/include"
     bin.install 'bmdcapture'
     bin.install 'bmdgenlock'
     bin.install 'bmdplay'
  end
end
