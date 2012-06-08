require 'formula'

class Pipemeter < Formula
  url 'https://launchpad.net/pipemeter/trunk/1.1.3/+download/pipemeter-1.1.3.tar.gz'
  homepage 'https://launchpad.net/pipemeter'
  md5 '55cf189d3d1de92bbc2bc7d3396e20b1'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    bin.install "pipemeter"
    man1.install "pipemeter.1"
  end
end
