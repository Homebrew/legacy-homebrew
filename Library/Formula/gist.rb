require 'formula'

class Gist <Formula
  url 'http://github.com/defunkt/gist/tarball/v1.2.1'
  homepage 'http://github.com/defunkt/gist'
  md5 'f89e4d059e35041acc215808a8d59cd5'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
