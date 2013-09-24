require 'formula'

class M < Formula
  homepage 'https://github.com/KevinSjoberg/m'
  url 'https://github.com/KevinSjoberg/m/archive/v0.0.1.tar.gz'
  version '0.0.1'
  sha1 '24898e60f333c125e19800acbff5e97b1010444d'

  def install
    (share/'m').install "m"
  end

  def caveats; <<-EOS.undent
    Make sure to add the following in your ~/.bashrc.

      source #{prefix}/share/m/m
    EOS
  end
end
