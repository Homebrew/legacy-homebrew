require 'formula'

class Pngxx < Formula
  homepage 'http://www.nongnu.org/pngpp/'
  url 'http://download.savannah.nongnu.org/releases/pngpp/png++-0.2.5.tar.gz'
  sha1 'bfe39c414a8c5c18dbaaf96fea22ce12a6887576'

  depends_on :libpng

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
