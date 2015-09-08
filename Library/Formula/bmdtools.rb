require 'formula'
 
class Bmdtools < Formula
  homepage 'http://github.com/lu-zero/bmdtools'
  url 'https://github.com/lu-zero/bmdtools/archive/v0.1.zip'
  sha256 'd79b4a9e4a1e6c5e4b54847015af6ff9f19ace586d50ce95068d790ebcbb79ec'
  head 'https://github.com/lu-zero/bmdtools.git'

  depends_on 'pkg-config' => :build
  depends_on 'decklinksdk' => :build
  depends_on 'ffmpeg'
 
  def install
     system "make", "SDK_PATH=#{Formula["decklinksdk"].opt_include}"
     bin.install 'bmdcapture'
     bin.install 'bmdgenlock'
     bin.install 'bmdplay'
  end
end
