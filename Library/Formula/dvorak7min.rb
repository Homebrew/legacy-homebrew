require 'formula'

class Dvorak7min < Formula
  homepage 'https://github.com/yaychris/dvorak7min'
  url 'https://github.com/yaychris/dvorak7min/archive/700f80569e1267ae42c8349bc5b6337387c6b5d0.tar.gz'
  version '1.6.1'
  sha1 '83f7ec4eba3fa33cf0547a8614ee02e50ff21c81'

  def install
    system "make"
    system "make INSTALL=#{prefix}/bin install"
  end
end
