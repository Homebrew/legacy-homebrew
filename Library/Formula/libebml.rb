require 'formula'

class Libebml < Formula
  homepage 'http://www.matroska.org/'
  url 'http://dl.matroska.org/downloads/libebml/libebml-1.3.0.tar.bz2'
  mirror 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.0.tar.bz2'
  sha256 '83b074d6b62715aa0080406ea84d33df2e44b5d874096640233a4db49b8096de'

  head 'https://github.com/Matroska-Org/libebml.git'

  bottle do
    cellar :any
    sha1 "5daf881f6849582832ee62064279dc3894ddb082" => :mavericks
    sha1 "0dbfecd7030ee7c9c283927509cc3b3351681e63" => :mountain_lion
    sha1 "02b8cacc1a5c9bcd8b07b2818a772db07b224dc3" => :lion
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "make", "-C", "make/linux", "install", "prefix=#{prefix}", "CXX=#{ENV.cxx}"
  end
end
