require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/tarball/v2.0.3'
  md5 '0b99159635df2083651d2ff9db8abb25'
  head 'https://github.com/defunkt/gist.git'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
