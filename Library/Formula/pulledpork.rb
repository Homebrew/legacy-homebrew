require 'formula'

class Pulledpork < Formula
  homepage 'http://code.google.com/p/pulledpork/'
  url 'https://pulledpork.googlecode.com/files/pulledpork-0.7.0.tar.gz'
  sha1 'fd7f2b195b473ba80826c4f06dd6ef2dd445814e'

  depends_on 'Switch' => :perl
  depends_on 'Crypt::SSLeay' => :perl

  def install
    bin.install 'pulledpork.pl'
    doc.install Dir['doc/*']
    etc.install Dir['etc/*']
  end
end
