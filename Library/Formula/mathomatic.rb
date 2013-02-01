require 'formula'

class Mathomatic < Formula
  homepage 'http://www.mathomatic.org/math/'
  url 'http://mathomatic.org/mathomatic-16.0.5.tar.bz2'
  sha1 'aaaf4df4aa3dc9ea748211278e657c2195858c24'

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
