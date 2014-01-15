require 'formula'

class Masscan < Formula
  homepage 'https://github.com/robertdavidgraham/masscan/'
  url 'https://github.com/robertdavidgraham/masscan/archive/1.0.1.tar.gz'
  sha1 '0b23454bc6c37fa7d095977601ff117588064e7f'
  head 'https://github.com/kaizoku/masscan.git'

  def install
    system "make"
    bin.install "bin/masscan"
  end

  test do
    assert `#{bin}/masscan --echo`.include? 'adapter ='
  end
end
