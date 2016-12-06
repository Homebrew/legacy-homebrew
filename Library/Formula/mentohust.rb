require 'formula'

class Mentohust < Formula
  homepage 'https://code.google.com/p/mentohust/'
  url 'https://mentohust.googlecode.com/files/mentohust_mac.tar.gz'
  sha1 '6b13c57ea7a41629d33ddc4380f0ca36684bc272'
  version '0.3.4'

  def install
    prefix.install Dir['*']
    system "mkdir #{bin}"
    system "ln -s #{prefix}/mentohust #{bin}/mentohust"
  end

end
