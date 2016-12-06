require 'formula'

class Plum < Formula
  homepage 'http://github.com/maximeh/plum/'
  url 'https://github.com/downloads/maximeh/plum/plum-0.1.tar.gz'
  md5 '601861c92af306b3b82089ca5e7b2e10'

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    man1.install "doc/plum.1"
  end

end

