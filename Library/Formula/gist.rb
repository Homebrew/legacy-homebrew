require 'formula'

class Gist < Formula
  url 'https://github.com/defunkt/gist/tarball/v2.0.2'
  homepage 'https://github.com/defunkt/gist'
  md5 'f43e0b5fd8cc3d0edab6aec840adf0b5'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
