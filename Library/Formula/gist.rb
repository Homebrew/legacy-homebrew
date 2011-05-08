require 'formula'

class Gist < Formula
  url 'https://github.com/defunkt/gist/tarball/v2.0.3'
  homepage 'https://github.com/defunkt/gist'
  md5 '5b9bfa8255e5f488b78a9d37a317b12a'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
