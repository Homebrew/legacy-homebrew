require 'formula'

class Libebml < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libebml/libebml-1.3.0.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.0.tar.bz2'
  sha256 '83b074d6b62715aa0080406ea84d33df2e44b5d874096640233a4db49b8096de'

  def install
    cd 'make/linux' do
      system "make", "install", "prefix=#{prefix}", "CXX=#{ENV.cxx}"
    end
  end
end
