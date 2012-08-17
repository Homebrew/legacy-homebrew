require 'formula'

class Rar < Formula
  homepage 'http://www.rarlab.com/'
  url 'http://www.rarlab.com/rar/rarosx-4.2.0.tar.gz'
  sha1 '20c0902650b842130aa3fc5c249c312bcd9d3440'

  def install
    prefix.install 'rar', 'unrar'
  end

  def test
    system 'rar'
    system 'unrar'
  end
end
