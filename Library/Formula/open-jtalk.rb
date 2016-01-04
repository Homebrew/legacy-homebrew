class OpenJtalk < Formula
  desc "Japanese text-to-speech system"
  homepage "http://open-jtalk.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/open-jtalk/Open%20JTalk/open_jtalk-1.09/open_jtalk-1.09.tar.gz"
  sha256 "8ed79238d825fee1d9e0a1c6c8a89e2cc707189be1caa3fa79e8eb72436079d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "23362fa7302809f689af8731920217cddef88e9ff0d73d3ef67101292d2fa1e6" => :el_capitan
    sha256 "1ff83a2c75f99b0cd0b7a3de1454c0b90382e6384e6be4afcd66a5d971b298f0" => :yosemite
    sha256 "c95c595beb973f17831291766a918c60525b225661faa02b31438a98808f66f8" => :mavericks
  end

  resource "hts_engine API" do
    url "https://downloads.sourceforge.net/project/hts-engine/hts_engine%20API/hts_engine_API-1.10/hts_engine_API-1.10.tar.gz"
    sha256 "e2132be5860d8fb4a460be766454cfd7c3e21cf67b509c48e1804feab14968f7"
  end

  resource "voice" do
    url "https://downloads.sourceforge.net/project/open-jtalk/HTS%20voice/hts_voice_nitech_jp_atr503_m001-1.05/hts_voice_nitech_jp_atr503_m001-1.05.tar.gz"
    sha256 "2e555c88482267b2931c7dbc7ecc0e3df140d6f68fc913aa4822f336c9e0adfc"
  end

  resource "mei" do
    url "https://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.6/MMDAgent_Example-1.6.zip"
    sha256 "2640ede5831a83e19f9cd8dabca9ad07ef05c50af06c6bc8cb3adfb5e5d4f639"
  end

  def install
    resource("hts_engine API").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end

    system "./configure", "--with-hts-engine-header-path=#{include}",
                          "--with-hts-engine-library-path=#{lib}",
                          "--with-charset=UTF-8",
                          "--prefix=#{prefix}"

    if MacOS.version <= :mavericks
      inreplace "config.status", "-finput-charset=UTF-8 -fexec-charset=UTF-8", ""
      # http://sourceforge.net/p/open-jtalk/mailman/message/33404251/
    end

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
