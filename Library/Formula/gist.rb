require 'formula'

class Gist < Formula
  url 'https://github.com/defunkt/gist/tarball/v2.0.1'
  homepage 'https://github.com/defunkt/gist'
  md5 'f6c8ef18f8019876cb54c9bfa3d4865b'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end
