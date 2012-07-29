require 'formula'

class Icecast < Formula
  url 'http://downloads.xiph.org/releases/icecast/icecast-2.3.3.tar.gz'
  homepage 'http://www.icecast.org/'
  md5 '2b5d1b40778922e5f6431b7758c359ad'

  depends_on 'libogg' => :optional
  depends_on 'theora' => :optional
  depends_on 'speex'  => :optional

  depends_on 'libvorbis'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    (prefix+'var/log/icecast').mkpath
    touch prefix+'var/log/icecast/error.log'
  end
end
