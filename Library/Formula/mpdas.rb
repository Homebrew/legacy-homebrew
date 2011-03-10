require 'formula'

class Mpdas < Formula
  url 'http://www.50hz.ws/mpdas/mpdas-0.2.5.tar.bz2'
  homepage 'http://www.50hz.ws/mpdas/'
  md5 'ea852645079be1aeedfe3e88f421917e'

  head 'git://github.com/hrkfdn/mpdas.git'

  depends_on 'pkg-config' => :build
  depends_on 'libmpd'

  def install
    ENV['PREFIX'] = prefix
    ENV['MANPREFIX'] = man
    ENV['CONFIG'] = etc

    ENV.j1
    system "make"
    # Just install ourselves
    bin.install "mpdas"
    man1.install "mpdas.1"
  end

  def caveats
    "Read #{prefix}/README on how to configure mpdas."
  end
end
