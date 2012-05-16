require 'formula'

class Mathomatic < Formula
  homepage 'http://www.mathomatic.org/math/'
  url 'http://mathomatic.org/mathomatic-15.8.4.tar.bz2'
  sha1 '2e5572685577050f0f0587c60c974bf4c34e0d60'

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
