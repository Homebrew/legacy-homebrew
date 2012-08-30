require 'formula'

class Mathomatic < Formula
  homepage 'http://www.mathomatic.org/math/'
  url 'http://mathomatic.org/mathomatic-16.0.1.tar.bz2'
  sha1 '7a3ba4a1e23f5f1898690cdad1ff2a79527e25fc'

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
