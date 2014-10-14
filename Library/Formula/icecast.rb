require 'formula'

class Icecast < Formula
  homepage 'http://www.icecast.org/'
  url 'http://downloads.xiph.org/releases/icecast/icecast-2.4.0.tar.gz'
  sha1 '45bd403c2b1d6f1250216cd3a0447d41f979c348'

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
