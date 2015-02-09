class OpenJtalk < Formula
  homepage "http://open-jtalk.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/open-jtalk/Open%20JTalk/open_jtalk-1.08/open_jtalk-1.08.tar.gz"
  sha256 "4771014f71734653b158e1723fd8c5c4440246a1fcc83491d6aa1c791ee2109e"

  resource "hts_engine API" do
    url "https://downloads.sourceforge.net/project/hts-engine/hts_engine%20API/hts_engine_API-1.09/hts_engine_API-1.09.tar.gz"
    sha256 "b35a9c7c6868e15be0fbfb91c7a3696cf623d82f2d2058d2fa4362c289b62895"
  end

  resource "voice" do
    url "http://downloads.sourceforge.net/project/open-jtalk/HTS%20voice/hts_voice_nitech_jp_atr503_m001-1.05/hts_voice_nitech_jp_atr503_m001-1.05.tar.gz"
    sha256 "2e555c88482267b2931c7dbc7ecc0e3df140d6f68fc913aa4822f336c9e0adfc"
  end

  resource "mei" do
    url "http://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.4/MMDAgent_Example-1.4.zip"
    sha256 "44096d92a8d2aef0e6079dc18cf0ec25f557aa5df5476c8c8b099cba8019c11a"
  end

  def install
    resource("hts_engine API").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end

    args = %W[
      --with-hts-engine-header-path=#{include}
      --with-hts-engine-library-path=#{lib}
      --with-charset=UTF-8
      --prefix=#{prefix}
    ]

    system "./configure", *args

    inreplace "config.status", "-finput-charset=UTF-8 -fexec-charset=UTF-8", ""
    # http://sourceforge.net/p/open-jtalk/mailman/message/33404251/

    system "make", "install"

    resource("voice").stage do
      (prefix/"voice/m100").install Dir["*"]
    end

    resource("mei").stage do
      (prefix/"voice").install "Voice/mei"
    end
  end

  test do
    (testpath/"sample.txt").write "OpenJTalkのインストールが完了しました。"
    system bin/"open_jtalk",
      "-x", "#{prefix}/dic",
      "-m", "#{prefix}/voice/mei/mei_normal.htsvoice",
      "-ow", "out.wav",
      "sample.txt"
  end
end
