require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.8.3'
  homepage 'https://github.com/defunkt/hub#readme'
  head 'https://github.com/defunkt/hub.git'
  md5 '8775c2312ba2b175775a81e9b0bf5e24'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
