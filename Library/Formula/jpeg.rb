require 'formula'

class Jpeg < Formula
  url 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  sha1 'f080b2fffc7581f7d19b968092ba9ebc234556ff'
  homepage 'http://www.ijg.org'
  version '8d'

  def install
    ENV.universal_binary   # Builds universal libs. Default is static & shared.
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
