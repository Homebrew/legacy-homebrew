require 'formula'

class Dub < Formula
  homepage 'http://registry.vibed.org/'
  url  'https://github.com/rejectedsoftware/dub/archive/v0.9.17.tar.gz'
  sha1 'fb73ad9ab50d2361963193d5147f942049c6d51b'

  head 'https://github.com/rejectedsoftware/dub.git'

  depends_on 'pkg-config' => :build
  depends_on 'dmd'  => :build

  def install
    system "./build.sh"
    bin.install 'bin/dub'
  end

  test do
    system "#{bin}/dub; true"
  end
end
