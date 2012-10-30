require 'formula'

class CurlCaBundle < Formula
  homepage 'http://curl.haxx.se/docs/caextract.html'
  version '1.86'
  url 'http://curl.haxx.se/ca/cacert.pem'
  sha1 '05fb1ab1bd495461959defb7a5f90116e6e96ca4'

  def install
    require 'fileutils'
    FileUtils.mkdir_p "/usr/local/ssl/certs"
    share.install("cacert.pem")
    File.unlink "/usr/local/ssl/certs/ca-bundle.crt"
    FileUtils.ln_s "#{share}/cacert.pem", "/usr/local/ssl/certs/ca-bundle.crt"
  end

  def test
    system "test", "-f", "/usr/local/ssl/certs/ca-bundle.crt"
  end
end
