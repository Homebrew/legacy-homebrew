require 'formula'

class EchoprintCodegen < Formula
  head 'https://github.com/echonest/echoprint-codegen.git'
  homepage 'http://echoprint.me'

  depends_on 'ffmpeg'
  depends_on 'taglib'
  depends_on 'boost'

  def install
    system "cd src; PREFIX=#{prefix} make install"
  end
end
