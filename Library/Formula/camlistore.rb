require 'formula'

class Camlistore < Formula
  homepage 'http://camlistore.org'
  head 'https://camlistore.googlesource.com/camlistore', :using => :git
  url 'https://github.com/bradfitz/camlistore/archive/0.6.tar.gz'
  sha1 'ca2a530fb2eb39a6cecf2f60e290934a9b6414f4'

  depends_on 'pkg-config' => :build
  depends_on 'go' => :build
  depends_on 'sqlite'

  def install
    ENV['GIT_DIR'] = cached_download+".git"

    system "go", "run", "make.go"
    prefix.install "bin/README"
    prefix.install "bin"
  end

  test do
    system bin/"camget", "-version"
  end
end
