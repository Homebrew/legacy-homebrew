require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.6.1'
  homepage 'https://github.com/defunkt/hub'
  head 'https://github.com/defunkt/hub.git'
  md5 'a1e87ad54076f075f5d337ff8e0cc144'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
