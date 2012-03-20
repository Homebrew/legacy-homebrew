require 'formula'

class Gist < Formula
  homepage 'https://github.com/defunkt/gist'
  url 'https://github.com/defunkt/gist/tarball/v3.0.1'
  md5 '88c3fdb6c1503c36942b62f8684c1798'
  head 'https://github.com/defunkt/gist.git'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
