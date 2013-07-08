require 'formula'

class CurlCaBundle < Formula
  homepage 'http://curl.haxx.se/docs/caextract.html'
  url 'https://downloads.sourceforge.net/project/machomebrew/mirror/curl-ca-bundle-1.87.tar.bz2'
  sha256 '41742f0c6aa689543ad037d1f7615b8620dae399d3cf2061a8d86d84a1b41f7f'

  def install
    share.install 'ca-bundle.crt'
  end
end
