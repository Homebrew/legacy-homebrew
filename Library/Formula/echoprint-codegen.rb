require 'formula'

class EchoprintCodegen < Formula
  homepage 'http://echoprint.me'
  url 'https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz'
  sha256 'c40eb79af3abdb1e785b6a48a874ccfb0e9721d7d180626fe29c72a29acd3845'
  head 'https://github.com/echonest/echoprint-codegen.git'
  bottle do
    cellar :any
    sha1 "f5b4717ff9bf8477d1bbade0a0366ebd04f8418a" => :mavericks
    sha1 "c56f2c25dc55d0d3904c741b75626f9d4f92d1f2" => :mountain_lion
    sha1 "0a684bf5d441627d830e1f52e02ffca5201b3470" => :lion
  end

  revision 1

  depends_on 'ffmpeg'
  depends_on 'taglib'
  depends_on 'boost'

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
