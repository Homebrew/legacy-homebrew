require 'formula'

class Grok < Formula
  desc "Powerful pattern-matching/reacting too"
  homepage 'https://github.com/jordansissel/grok'
  url 'https://github.com/jordansissel/grok/archive/v0.9.2.tar.gz'
  sha1 'ca87b2a21d67b3fda74f209db22f7e1773edd7e8'
  head 'https://github.com/jordansissel/grok.git'

  depends_on 'libevent'
  depends_on 'pcre'
  depends_on 'tokyo-cabinet'

  def install
    system "make grok"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
