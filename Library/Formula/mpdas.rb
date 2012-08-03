require 'formula'

class Mpdas < Formula
  homepage 'http://www.50hz.ws/mpdas/'
  url 'http://www.50hz.ws/mpdas/mpdas-0.3.0.tar.bz2'
  sha1 '3e389b8bb9a37b7f9527c6c4a1aaaf4ab462bf0a'

  head 'https://github.com/hrkfdn/mpdas.git'

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
