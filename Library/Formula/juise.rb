require 'formula'

class Juise < Formula
  homepage 'http://code.google.com/p/juise/'
  url 'http://juise.googlecode.com/files/juise-0.3.10.tar.gz'
  sha1 '1e3c0f5e98ee3f499b5180512cc98e294c551fde'

  depends_on 'libxml2' if MacOS.version >= 10.7 # Lion's libxml is too old. Need > 2.7.8
  depends_on 'libxslt' if MacOS.version >= 10.7 # Lion's libxslt is too old. Need > 1.1.26
  depends_on 'libslax'

  def install
    ENV.libxml2 if MacOS.mountain_lion?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
