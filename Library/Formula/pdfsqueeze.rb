require 'formula'

class Pdfsqueeze < Formula
  homepage 'http://code.google.com/p/pdfsqueeze/'
  url 'http://pdfsqueeze.googlecode.com/files/pdfsqueeze.tar.bz2'
  sha1 '1be85edbe44bbcc0a0a12841047904bef0eba02f'
  version '1'

  def install
    bin.install 'pdfsqueeze'
  end

  def test
    system 'which pdfsqueeze'
  end
end
