require 'formula'

class EchoprintCodegen < Formula
  homepage 'http://echoprint.me'
  head 'https://github.com/echonest/echoprint-codegen.git'

  depends_on 'ffmpeg'
  depends_on 'taglib'
  depends_on 'boost'

  def install
    cd 'src' do
      system "make", "install", "PREFIX=#{prefix}"
    end
  end
end
