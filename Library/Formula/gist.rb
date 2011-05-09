require 'formula'

class Gist < Formula
  url 'https://github.com/defunkt/gist/tarball/v2.0.3'
  homepage 'https://github.com/defunkt/gist'
  md5 '0b99159635df2083651d2ff9db8abb25'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
