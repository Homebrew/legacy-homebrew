require 'formula'

class Magit < Formula
  url 'https://github.com/downloads/philjackson/magit/magit-0.8.2.tar.gz'
  homepage 'https://github.com/philjackson/magit'
  md5 'fe7e1a1085190ede6bed49e406fe0ce9'
  head 'git://github.com/philjackson/magit.git'

  def install
    system "./autogen.sh" if File.exist? "autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
