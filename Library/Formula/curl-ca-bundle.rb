require 'formula'

class CurlCaBundle < Formula
  homepage 'http://curl.haxx.se/docs/caextract.html'
  url 'http://curl.haxx.se/download/curl-7.28.1.tar.gz'
  sha256 '78dce7cfff51ec5725442b92c00550b4e0ca2f45ad242223850a312cd9160509'
  version '1.87'

  def install
    cd 'lib' do
      inreplace 'mk-ca-bundle.pl', /(http):/, '\1s:'
      system 'perl', 'mk-ca-bundle.pl'
      share.install 'ca-bundle.crt'
    end
  end
end
