require 'formula'

class Libmatroska < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-1.3.0.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.3.0.tar.bz2'
  sha1 '81c5a812604c0f05c471230e05b8cbc4542226fc'

  depends_on 'libebml'

  def install
    cd 'make/linux' do
      system "make", "install", "prefix=#{prefix}", "CXX=#{ENV.cxx}"
    end
  end
end
