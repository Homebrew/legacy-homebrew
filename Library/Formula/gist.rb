require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/tarball/v3.1.0'
  md5 'fde73d0653ff9bf07f0b9e2f72090f20'
  head 'https://github.com/defunkt/gist.git'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
