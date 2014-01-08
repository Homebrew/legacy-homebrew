require 'formula'

class Acpica < Formula
  homepage 'https://www.acpica.org/'
  url 'https://acpica.org/sites/acpica/files/acpica-unix2-20130823.tar.gz'
  sha1 'a10f2a3708d02074e283ee105dd3fcc6e1940c3e'

  head 'https://github.com/acpica/acpica.git'

  def install
    ENV.deparallelize
    system "make", "HOST=_APPLE", "PREFIX=#{prefix}"
    system "make", "install", "HOST=_APPLE", "PREFIX=#{prefix}"
  end
end
