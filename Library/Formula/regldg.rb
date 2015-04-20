require 'formula'

class Regldg < Formula
  homepage 'http://regldg.com'
  url 'http://regldg.com/regldg-1.0.0.tar.gz'
  sha1 '1a355c1898f90b6a725e2ddc39b4daa2ce83b856'

  def install
    system "make"
    bin.install "regldg"
  end

  test do
    system "#{bin}/regldg", "test"
  end
end
