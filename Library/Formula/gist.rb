require 'formula'

class Gist <Formula
  url 'http://github.com/indirect/gist/tarball/v1.4.0'
  homepage 'http://github.com/defunkt/gist'
  md5 '014c3c8f02b7b46a0ea986da29dd9f18'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
