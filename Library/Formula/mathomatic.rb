require 'formula'

class Mathomatic < Formula
  homepage 'http://www.mathomatic.org/math/'
  url 'http://mathomatic.org/mathomatic-16.0.2.tar.bz2'
  sha1 'd480c0a9893186151bf22cef166e20a94fcf1335'

  def install
    ENV['prefix'] = prefix
    system "make READLINE=1"
    system "make m4install"
    cd 'primes' do
      system 'make'
      system 'make install'
    end
  end
end
