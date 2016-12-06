require 'formula'

class OpenalSoft < Formula
  url 'http://kcat.strangesoft.net/openal-releases/openal-soft-1.13.tar.bz2'
  homepage 'http://kcat.strangesoft.net/openal.html'
  md5 '58b7d2809790c70681b825644c5f3614'
  version '1.13'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
