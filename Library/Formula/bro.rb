require 'formula'

class Bro < Formula
  homepage 'http://www.bro-ids.org/'
  url 'http://www.bro-ids.org/downloads/release/bro-2.3.tar.gz'
  sha1 '79397be0e351165d44047b044d29b5e6580532cc'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'geoip' => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
