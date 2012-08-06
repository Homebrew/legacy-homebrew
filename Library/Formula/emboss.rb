require 'formula'

class Emboss < Formula
  url 'ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.5.7.tar.gz'
  homepage 'http://emboss.sourceforge.net/'
  sha1 '907231eafe07917ae0bf9c5da2e7cdc3e9bae03a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
