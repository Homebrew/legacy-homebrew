class Wemux < Formula
  desc "Enhances tmux's to provide multiuser terminal multiplexing"
  homepage "https://github.com/zolrath/wemux"
  url "https://github.com/zolrath/wemux/archive/v3.2.0.tar.gz"
  sha256 "8de6607df116b86e2efddfe3740fc5eef002674e551668e5dde23e21b469b06c"

  head "https://github.com/zolrath/wemux.git"

  bottle do
    cellar :any
    sha256 "582fd8b518b4103818772669694a0c6486cf346506d52c364cfbe01f4ab5b46b" => :mavericks
    sha256 "f898bd7ec33a8f12691d7cfdb4cf976184e13d5d89241c7b1e0b194442d018e8" => :mountain_lion
    sha256 "6842513f2fd6940e9905a6955394b8648935a6fd5fa4e94449d4a4711edf7bb8" => :lion
  end

  depends_on "tmux"

  def install
    inreplace "wemux", "/usr/local/etc", etc
    bin.install "wemux"
    man1.install "man/wemux.1"

    inreplace "wemux.conf.example", "change_this", ENV["USER"]
    etc.install "wemux.conf.example" => "wemux.conf"
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
