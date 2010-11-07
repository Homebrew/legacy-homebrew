require 'formula'

class Gist < Formula
  url 'http://github.com/defunkt/gist/tarball/v1.4.1'
  homepage 'http://github.com/defunkt/gist'
  md5 '424af9443b8ef35964045dd8943a224e'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
