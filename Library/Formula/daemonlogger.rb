require 'formula'

class Daemonlogger < Formula
  homepage 'http://www.snort.org/snort-downloads/additional-downloads#daemonlogger'
  url 'http://www.snort.org/downloads/463'
  version '1.2.1'
  sha1 'ce0aa20b38f18eca94a6d00fe9126d441fe2818a'

  depends_on 'libdnet'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
