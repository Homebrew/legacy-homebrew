require 'formula'

class Libmatroska < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.1.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.1.tar.bz2'
  sha256 '086f21873e925679babdabf793c3bb85c353d0cd79423543a3355e08e8a4efb7'

  option :cxx11

  if build.cxx11?
    depends_on 'libebml' => 'c++11'
  else
    depends_on 'libebml'
  end

  def install
    ENV.cxx11 if build.cxx11?

    cd 'make/linux' do
      system "make", "install", "prefix=#{prefix}", "CXX=#{ENV.cxx}"
    end
  end
end
