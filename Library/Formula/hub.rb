require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.6.0'
  homepage 'https://github.com/defunkt/hub'
  head 'git://github.com/defunkt/hub.git'
  md5 '6347bee90f0ae5b7b7fc5c9e971f61b8'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
