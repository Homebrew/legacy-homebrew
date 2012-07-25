require 'formula'

class Grok < Formula
  homepage 'https://github.com/jordansissel/grok'
  url 'https://github.com/jordansissel/grok/tarball/v0.9.2'
  md5 '1e7df1f5e3f9ecfc6584cc34ee6f2983'
  head 'https://github.com/jordansissel/grok.git'

  depends_on 'libevent'
  depends_on 'tokyo-cabinet'

  def install
    system "make grok"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
