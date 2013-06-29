require 'formula'

class Dub < Formula
  homepage 'http://registry.vibed.org/'
  url  'https://github.com/rejectedsoftware/dub/archive/v0.9.15.tar.gz'
  sha1 '408216dae221ca19220f91f9081b2f8e0d8a5484'

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
