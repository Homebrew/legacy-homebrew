require 'formula'

class LiveF1 < Formula
  url 'http://launchpad.net/live-f1/0.2/0.2.11/+download/live-f1-0.2.11.tgz'
  homepage 'https://launchpad.net/live-f1'
  md5 'f8251707da8bc0368c9b949c1672135b'

  depends_on 'gettext'
  depends_on 'neon'

  def install
    system "autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
