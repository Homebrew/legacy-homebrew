require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.8.0'
  homepage 'https://github.com/defunkt/hub#readme'
  head 'https://github.com/defunkt/hub.git'
  md5 '66476abc43e3d0a9ad4e4675e6e3ca0c'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
