require 'formula'

class Masscan < Formula
  homepage 'https://github.com/robertdavidgraham/masscan/'
  url 'https://github.com/robertdavidgraham/masscan/archive/1.0.3.tar.gz'
  sha1 'a10a2475e97c7d2b2999e4c9ce9e19863782dc8f'
  head 'https://github.com/kaizoku/masscan.git'

  def install
    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert `#{bin}/masscan --echo`.include? 'adapter ='
  end
end
