require 'formula'

class Raptor < Formula
  url 'http://download.librdf.org/source/raptor2-2.0.4.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '0373efb8d85dc872bc7bb5b1c69299fb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
