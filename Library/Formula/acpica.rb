require 'formula'

class Acpica < Formula
  homepage 'https://www.acpica.org/'
  url 'https://acpica.org/sites/acpica/files/acpica-unix2-20130517.tar.gz'
  sha1 '527fd7c06d7cb7182dd2f3f9a1feb55e2271adc3'

  def install
    ENV.deparallelize
    system "make", "HOST=_APPLE", "PREFIX=#{prefix}"
    system "make", "install", "HOST=_APPLE", "PREFIX=#{prefix}"
  end
end
