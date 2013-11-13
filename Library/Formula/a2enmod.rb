require 'formula'

class A2enmod < Formula
  homepage 'https://github.com/rudisimo/a2enmod'
  url 'https://github.com/rudisimo/a2enmod/archive/v0.1.0.tar.gz'
  sha1 '4d0fa7509fc06e4fd9a015768ee1090a20580be2'

  head 'https://github.com/rudisimo/a2enmod.git'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
