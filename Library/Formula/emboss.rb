require 'formula'

class Emboss < Formula
  homepage 'http://emboss.sourceforge.net/'
  url 'ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.5.7.tar.gz'
  sha1 '907231eafe07917ae0bf9c5da2e7cdc3e9bae03a'

  depends_on 'pkg-config' => :build
  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
