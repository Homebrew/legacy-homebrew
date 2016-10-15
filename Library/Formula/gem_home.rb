require 'formula'

class GemHome < Formula
  homepage 'https://github.com/postmodern/gem_home#readme'
  url 'https://github.com/postmodern/gem_home/archive/v0.1.0.tar.gz'
  sha1 '338193cbbda0ee7bf0d3c903bb75fd24a4933693'

  head 'https://github.com/postmodern/gem_home.git'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
