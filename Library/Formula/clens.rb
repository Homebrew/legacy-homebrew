require 'formula'

class Clens < Formula
  homepage 'https://opensource.conformal.com/wiki/clens'
  url 'https://github.com/conformal/clens/archive/CLENS_0_7_0.tar.gz'
  sha1 '565ca40e4389c835c12f4898ea6b355425e62e27'

  patch do
    url "https://github.com/conformal/clens/commit/83648cc9027d9f76a1bc79ddddcbed1349b9d5cd.diff"
    sha1 "52de3f7ea0f7a9857ec81a0f93c4e82cb9d762fd"
  end

  def install
    ENV.j1
    system "make", "all", "install", "LOCALBASE=#{prefix}"
  end
end
