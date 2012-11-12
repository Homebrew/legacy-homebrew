require 'formula'

class Mathomatic < Formula
  homepage 'http://www.mathomatic.org/math/'
  url 'http://mathomatic.org/mathomatic-16.0.4.tar.bz2'
  sha1 'cf6d89f3f454c27a946786587a7dc3b47a79ae3f'

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
