require 'formula'

class Pan < Formula
  homepage 'http://pan.rebelbase.com/'
  url 'http://pan.rebelbase.com/download/releases/0.139/source/pan-0.139.tar.bz2'
  sha1 '01ea0361a6d81489888e6abb075fd552999c3c60'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'gmime'
  depends_on 'intltool'
  depends_on 'enchant' => :optional
  depends_on 'd-bus' => :optional
  depends_on 'gnutls' => :optional

  def install
    ENV.x11
    ENV.append 'LDFLAGS', ' -liconv ' # iconv detection is broken.

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
