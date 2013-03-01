require 'formula'

class Pulledpork < Formula
  homepage 'http://code.google.com/p/pulledpork/'
  url 'http://pulledpork.googlecode.com/files/pulledpork-0.6.1.tar.gz'
  sha1 'b95b62f52213c6074a2e8c57c2adc7d038d9c0cd'

  depends_on 'Switch' => :perl
  depends_on 'Crypt::SSLeay' => :perl

  def install
    bin.install 'pulledpork.pl'
    doc.install Dir['doc/*']
    etc.install Dir['etc/*']
  end
end
