require 'formula'

class Gist < Formula
  url 'https://github.com/defunkt/gist/tarball/v2.0.0'
  homepage 'http://github.com/defunkt/gist'
  md5 '4be2158b5a3d570f0f14d3ba092458db'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
