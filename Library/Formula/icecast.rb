require 'formula'

class Icecast < Formula
  homepage 'http://www.icecast.org/'
  url 'http://downloads.xiph.org/releases/icecast/icecast-2.4.1.tar.gz'
  sha1 '0ec1a6470554cccd9ca48488776a26887e9b9a5e'

  depends_on 'pkg-config' => :build
  depends_on 'libogg' => :optional
  depends_on 'theora' => :optional
  depends_on 'speex'  => :optional
  depends_on 'openssl'
  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    (prefix+'var/log/icecast').mkpath
    touch prefix+'var/log/icecast/error.log'
  end
end
