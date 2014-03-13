require 'formula'

class Wemux < Formula
  homepage 'https://github.com/zolrath/wemux'
  url 'https://github.com/zolrath/wemux/archive/v3.2.0.tar.gz'
  sha1 '099e6afbd5313aadd9a4dae7fc416f3846888624'

  head 'https://github.com/zolrath/wemux.git'

  bottle do
    cellar :any
    sha1 "4f67e551a15578c2af0304ef41b96f8b00889283" => :mavericks
    sha1 "9ae3fc6f6d24fe035c5c1df2c86bfa189ea744b3" => :mountain_lion
    sha1 "7f5f6a408d6895cd90c33593d3c89dbffae15893" => :lion
  end

  depends_on 'tmux'

  def install
    inreplace 'wemux', '/usr/local/etc', etc
    bin.install 'wemux'
    man1.install 'man/wemux.1'

    inreplace 'wemux.conf.example', 'change_this', ENV['USER']
    etc.install 'wemux.conf.example' => 'wemux.conf'
  end

  def caveats; <<-EOS.undent
    Your current user account has been automatically added as a wemux host.

    To give a user the ability to host wemux sessions add them to the
    host_list array in:
      #{etc}/wemux.conf

    Either edit the file in your text editor of choice or run `wemux conf` to
    open the file in your $EDITOR.
    EOS
  end

  test do
    system "#{bin}/wemux", "help"
  end
end
