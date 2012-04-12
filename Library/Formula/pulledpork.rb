require 'formula'

class Pulledpork < Formula
  homepage 'http://code.google.com/p/pulledpork/'
  url 'http://pulledpork.googlecode.com/files/pulledpork-0.6.1.tar.gz'
  md5 'a35c5c89d1f631ade1a2cd4e5c3a8778'

  depends_on 'Switch' => :perl
  depends_on 'Crypt::SSLeay' => :perl

  def install
    bin.install 'pulledpork.pl'
    doc.install Dir['doc/*']
    etc.install Dir['etc/*']
  end
end
