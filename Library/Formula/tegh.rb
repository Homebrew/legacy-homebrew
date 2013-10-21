require 'formula'

class Tegh < Formula
  homepage 'https://github.com/D1plo1d/tegh'
  head 'https://github.com/D1plo1d/tegh.git', :branch => 'develop'
  url 'https://s3.amazonaws.com/tegh_binaries/0.3.0/tegh-0.3.0-brew.tar.gz'
  sha1 'ffdffdf566c99db683a806c2357517d71b5fc5ca'

  depends_on 'node'

  def install
    system "npm", "install" if build.head?
    prefix.install Dir['*']
  end

  test do
    system "tegh"
  end
end
