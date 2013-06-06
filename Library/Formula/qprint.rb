require 'formula'

class Qprint < Formula
  homepage 'http://www.fourmilab.ch/webtools/qprint'
  url 'http://www.fourmilab.ch/webtools/qprint/qprint-1.0.tar.gz'
  sha1 '533a4942e93cccc2e6b3fd2171707bf1d0054d20'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    bin.install "qprint"
    man1.install "qprint.1"
  end
end
