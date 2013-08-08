require 'formula'

class Tegh < Formula
  homepage 'https://github.com/D1plo1d/tegh'
  head 'https://github.com/D1plo1d/tegh.git'
  url 'https://s3.amazonaws.com/tegh_binaries/0.2.0/tegh-0.2.0-brew.tar.gz'
  sha1 '5c62b5cae11138b7773ad5fd4c596eb7990366e2'

  depends_on 'node'

  def install
    system "npm", "install" if build.head?
    prefix.install Dir['*']
  end

  test do
    system "tegh"
  end
end
