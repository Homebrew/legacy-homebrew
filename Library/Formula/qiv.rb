require 'formula'

class Qiv < Formula
  homepage 'http://spiegl.de/qiv/'
  url 'http://spiegl.de/qiv/download/qiv-2.2.4.tgz'
  sha1 '650052cb72820701300b2bfeb09b966625ee3dba'

  head 'http://bitbucket.org/ciberandy/qiv/', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'imlib2'
  depends_on 'libmagic'

  def install
    system "make", 'STATUSBAR_FONT="Monaco"', "CC=#{ENV.cc}"
    bin.install "qiv"
    man1.install "qiv.1"
  end

  def test
    system "#{bin}/qiv"
  end
end
