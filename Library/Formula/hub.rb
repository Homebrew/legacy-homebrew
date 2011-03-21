require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.5.1'
  homepage 'https://github.com/defunkt/hub'
  head 'git://github.com/defunkt/hub.git'
  md5 'a2e86a15fc58399544e7c3e749ac642f'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
