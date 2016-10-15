require 'formula'

class Tg < Formula
  homepage 'https://github.com/vysheng/tg'
  version '0.01-beta'
  url 'https://github.com/vysheng/tg/archive/75194f4552406098ff09c761a8434849b38d8236.zip'
  sha1 '57da7dfc9c8596f49f0a07799eef4d067cf87378'

  head 'https://github.com/vysheng/tg.git', :branch => 'master'

  depends_on 'libconfig'
  depends_on 'readline'
  depends_on 'lua'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    prefix.install "tg.pub"
    bin.install "telegram"
  end

  def caveats
    <<-EOS.undent
      You need a public server key to launch Telegram messenger CLI.
      By default the public key could be stored in the same folder named tg.pub or in /etc/telegram named server.pub:

          sudo mkdir /etc/telegram
          sudo ln -sf #{prefix}/tg.pub /etc/telegram/server.pub

      Furthermore, you could specify where to find it:

          telegram -k <public-server-key>

    EOS
  end
end
