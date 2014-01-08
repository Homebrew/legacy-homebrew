require 'formula'

class Exiv2 < Formula
  homepage 'http://www.exiv2.org'
  url 'http://www.exiv2.org/exiv2-0.24.tar.gz'
  sha1 '2f19538e54f8c21c180fa96d17677b7cff7dc1bb'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
