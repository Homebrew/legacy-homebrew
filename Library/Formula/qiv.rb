require 'formula'

class Qiv < Formula
  homepage 'http://spiegl.de/qiv/'
  url 'http://spiegl.de/qiv/download/qiv-2.2.4.tgz'
  sha1 '650052cb72820701300b2bfeb09b966625ee3dba'
  head 'http://bitbucket.org/ciberandy/qiv/', :using => :hg

  depends_on 'gtk+'
  depends_on 'imlib2'
  depends_on 'libmagic'

  def install
    ENV.deparallelize
    ENV.no_optimization
    inreplace "Makefile" do |s|
      s.change_make_var! "STATUSBAR_FONT", '"Monaco"'
    end
    system "make"
    bin.install "qiv"
    man1.install "qiv.1"
  end

  def test
    system "qiv"
  end
end
