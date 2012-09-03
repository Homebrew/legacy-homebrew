require 'formula'

class Grok < Formula
  homepage 'https://github.com/jordansissel/grok'
  url 'https://github.com/jordansissel/grok/tarball/v0.9.2'
  sha1 '909e2711b35962cf0119e873de751409da222c7d'
  head 'https://github.com/jordansissel/grok.git'

  depends_on 'libevent'
  depends_on 'tokyo-cabinet'

  def install
    system "make grok"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
