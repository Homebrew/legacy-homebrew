require 'formula'

class LuaNginxModule < Formula
  homepage 'https://github.com/chaoslawful'
  url 'https://github.com/chaoslawful/lua-nginx-module/archive/v0.8.3rc1.tar.gz'
  sha1 '49b2fa946517fb2e9b26185d418570e98ff5ff51'

  def install
    prefix.install Dir['*']
  end

end
