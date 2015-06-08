require 'formula'

class Opus < Formula
  desc "Audio codec"
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz'
  sha1 '35005f5549e2583f5770590135984dcfce6f3d58'

  bottle do
    cellar :any
    sha1 "5fb89890cfc8c254a6f13f9657a66da385887b2b" => :yosemite
    sha1 "8ac2e93276b0df2f69c01d0b727fbff57a637e9e" => :mavericks
    sha1 "a7e6ed2455861c41e021fec280b6fa28462341a2" => :mountain_lion
  end

  option "with-custom-modes", "Enable custom-modes for opus see http://www.opus-codec.org/docs/html_api-1.1.0/group__opus__custom.html"

  head do
    url 'https://git.xiph.org/opus.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end
end
