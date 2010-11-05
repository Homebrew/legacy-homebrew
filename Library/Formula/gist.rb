require 'formula'

class Gist < Formula
  url 'http://github.com/indirect/gist/tarball/v1.3.0'
  homepage 'http://github.com/defunkt/gist'
  md5 '8fc9a5e7261611d39b56e1b9d4b48474'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
