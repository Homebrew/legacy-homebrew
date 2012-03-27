require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.8.4'
  homepage 'https://github.com/defunkt/hub#readme'
  head 'https://github.com/defunkt/hub.git'
  md5 '1ca041817c014d2d3a5267f2aed4157b'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
