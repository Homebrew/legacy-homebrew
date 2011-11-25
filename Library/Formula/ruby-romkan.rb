require 'formula'

class RubyRomkan < Formula
  url 'http://0xcc.net/ruby-romkan/ruby-romkan-0.4.tar.gz'
  homepage 'http://0xcc.net/ruby-romkan/'
  md5 'bc48a51bd6cf0e4ff1d73faffef531fb'

  def install
    system "mkdir -p #{prefix}/lib/ruby"
    system "install -c -m 644 romkan.rb #{prefix}/lib/ruby"
  end
end
