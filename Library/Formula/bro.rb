require 'formula'

class Bro < Formula
  homepage 'http://www.bro-ids.org/'
  url 'http://www.bro-ids.org/downloads/release/bro-2.2.tar.gz'
  sha1 'cd70c426ca0369f16919cf45ad3222e6287908df'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'libmagic'
  depends_on 'geoip' => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
