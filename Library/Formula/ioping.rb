require 'formula'

class Ioping < Formula
  homepage 'http://code.google.com/p/ioping/'
  url 'https://ioping.googlecode.com/files/ioping-0.8.tar.gz'
  sha1 '7d4fe1414cdd5887c332426a8844e17eca5e5646'

  head 'http://ioping.googlecode.com/svn/trunk/'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-v"
  end
end
