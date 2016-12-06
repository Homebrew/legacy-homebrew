require 'formula'

class ServiceConfig < Formula
  url 'http://www.superscript.com/service-config/service-config-0.51.tar.gz'
  homepage 'http://www.superscript.com/service-config/intro.html'
  md5 '6bb4cbbe3ac2e2aaa9627b4c281de0d4'

  depends_on 'daemontools'

  def install
    system "make"
    bin.install Dir['*-config']
  end
end
