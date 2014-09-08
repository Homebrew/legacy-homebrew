require 'formula'

class EchoprintCodegen < Formula
  homepage 'http://echoprint.me'
  url 'https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz'
  sha256 'c40eb79af3abdb1e785b6a48a874ccfb0e9721d7d180626fe29c72a29acd3845'
  head 'https://github.com/echonest/echoprint-codegen.git'

  depends_on 'ffmpeg'
  depends_on 'taglib'
  depends_on 'boost'

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
