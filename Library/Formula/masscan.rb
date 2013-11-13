require 'formula'

class Masscan < Formula
  homepage 'https://github.com/robertdavidgraham/masscan/'
  url 'https://github.com/robertdavidgraham/masscan/archive/1.0.tar.gz'
  sha1 'c5a7604f52ba0d2578232c6c7a833d3a8756149f'
  head 'https://github.com/kaizoku/masscan.git'

  def install
    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert `#{bin}/masscan --echo`.include? 'adapter ='
  end
end
