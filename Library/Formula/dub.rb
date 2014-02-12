require 'formula'

class Dub < Formula
  homepage 'http://registry.vibed.org/'
  url  'https://github.com/rejectedsoftware/dub/archive/v0.9.20.tar.gz'
  sha1 '9fb51e7daf93153d81b2fb7e6e72654c0c19a501'

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
