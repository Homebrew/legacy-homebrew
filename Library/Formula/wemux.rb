require 'formula'

class Wemux < Formula
  homepage 'https://github.com/zolrath/wemux'
  url 'https://github.com/downloads/zolrath/wemux/wemux-3.1.0.tar.gz'
  md5 '15d11e495f2c166690b3ca7426c3bc0f'
  head 'https://github.com/zolrath/wemux.git'

  depends_on 'tmux'

  def install
    inreplace "wemux.conf.example", 'change_this', ENV['USER']
    etc.install 'wemux.conf.example' => 'wemux.conf'
    man1.install 'man/wemux.1'
    bin.install 'wemux'
  end

  def caveats; <<-EOS.undent
    Your current user account has been automatically added as a wemux host.

    To give a user the ability to host wemux sessions add them to the
    host_list array in #{etc}/wemux.conf

    Either edit the file in your text editor of choice or run `wemux conf` to
    open the file in your $EDITOR.
    EOS
  end

  def test
    system "#{bin}/wemux help"
  end
end
