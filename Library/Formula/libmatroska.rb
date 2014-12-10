require 'formula'

class Libmatroska < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.1.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.1.tar.bz2'
  sha256 '086f21873e925679babdabf793c3bb85c353d0cd79423543a3355e08e8a4efb7'

  head 'https://github.com/Matroska-Org/libmatroska.git'

  bottle do
    cellar :any
    revision 1
    sha1 "d39ff1121fdf2be3602e355e348d75c97834c03e" => :yosemite
    sha1 "3692b1c928884da200d91bc4158d3a0c340baaa9" => :mavericks
    sha1 "4b99118975bfd6c0cf9df4e35e62e33eafb787ac" => :mountain_lion
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
