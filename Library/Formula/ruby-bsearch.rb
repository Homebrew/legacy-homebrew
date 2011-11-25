require 'formula'

class RubyBsearch < Formula
  url 'http://0xcc.net/ruby-bsearch/ruby-bsearch-1.5.tar.gz'
  homepage 'http://0xcc.net/ruby-bsearch/'
  md5 'fb3cb15bb3546fb3b5d4ba5a61baeea1'

  def install
    system "mkdir -p #{prefix}/lib/ruby"
    system "install -c -m 644 bsearch.rb #{prefix}/lib/ruby"
  end
end
