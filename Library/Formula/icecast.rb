require 'formula'

class Icecast < Formula
  url 'http://downloads.xiph.org/releases/icecast/icecast-2.3.2.tar.gz'
  homepage 'http://www.icecast.org/'
  md5 'ff516b3ccd2bcc31e68f460cd316093f'

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
