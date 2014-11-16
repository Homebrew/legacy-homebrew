require 'formula'

class Libebml < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libebml/libebml-1.3.0.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.0.tar.bz2'
  sha256 '83b074d6b62715aa0080406ea84d33df2e44b5d874096640233a4db49b8096de'

  head 'https://github.com/Matroska-Org/libebml.git'

  bottle do
    cellar :any
    revision 1
    sha1 "50c10f93ac4f4d5d4f63d26b3175e2809dea4a0c" => :yosemite
    sha1 "ce19e183dee7ed41071fade3518a6ddcd7481aef" => :mavericks
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "make", "-C", "make/linux", "install", "prefix=#{prefix}", "CXX=#{ENV.cxx}"
  end
end
