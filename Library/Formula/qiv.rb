require 'formula'

class Qiv < Formula
  homepage 'http://spiegl.de/qiv/'
  url 'http://spiegl.de/qiv/download/qiv-2.3.tgz'
  sha1 '48ec74194c87e3100c3b435e61e0174e87e7b51c'

  head 'http://bitbucket.org/ciberandy/qiv/', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'imlib2'
  depends_on 'libmagic'
  depends_on 'little-cms2'
  depends_on 'libexif'

  def install
    system "make", 'STATUSBAR_FONT="Monaco"', "CC=#{ENV.cc}"
    bin.install "qiv"
    man1.install "qiv.1"
  end

  test do
    system "#{bin}/qiv"
  end
end
