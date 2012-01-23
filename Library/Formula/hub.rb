require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.7.0'
  homepage 'https://github.com/defunkt/hub'
  head 'https://github.com/defunkt/hub.git'
  md5 '90a9e0360afcc62d126724d78d0bb7ac'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
