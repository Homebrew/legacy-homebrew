require 'formula'

class Icecast < Formula
  homepage 'http://www.icecast.org/'
  url 'http://downloads.xiph.org/releases/icecast/icecast-2.3.3.tar.gz'
  sha1 '61cf1bd5b4ed491aad488dc6cf1ca2d8eb657363'

  depends_on 'pkg-config' => :build
  depends_on 'libogg' => :optional
  depends_on 'theora' => :optional
  depends_on 'speex'  => :optional

  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    (prefix+'var/log/icecast').mkpath
    touch prefix+'var/log/icecast/error.log'
  end
end
