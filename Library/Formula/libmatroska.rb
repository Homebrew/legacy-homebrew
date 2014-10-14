require 'formula'

class Libmatroska < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.1.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.1.tar.bz2'
  sha256 '086f21873e925679babdabf793c3bb85c353d0cd79423543a3355e08e8a4efb7'

  head 'https://github.com/Matroska-Org/libmatroska.git'

  bottle do
    cellar :any
    sha1 "8e92b18aa91b6905cb2d9a4972e1f6ed796023fb" => :mavericks
    sha1 "894ea667984226a36981fcaa61a36b0b43c6acbf" => :mountain_lion
    sha1 "4343c5cf40528137cbf66d0ca8c68d707d66260a" => :lion
  end

  option :cxx11

  if build.cxx11?
    depends_on 'libebml' => 'c++11'
  else
    depends_on 'libebml'
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "make", "-C", "make/linux", "install", "prefix=#{prefix}", "CXX=#{ENV.cxx}"
  end
end
