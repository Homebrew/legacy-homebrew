require 'formula'

class Openxcom < Formula
  homepage 'http://openxcom.org/'
  url 'https://github.com/SupSuper/OpenXcom/tarball/v0.4.5'
  sha1 '3a23900e22a4012fbfd6be576a23623daf23e5be'
  head 'https://github.com/SupSuper/OpenXcom.git'

  depends_on 'yaml-cpp' 
  depends_on 'sdl' 
  depends_on 'sdl_gfx' 
  depends_on 'sdl_mixer' 

  def install
    system "cd src && make -f Makefile.simple && cd .. "
    prefix.install "bin"
  end

  def test
    system "#{bin}/openxcom -h"
  end
end
