class OpenJtalk < Formula
  homepage "http://open-jtalk.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/open-jtalk/Open%20JTalk/open_jtalk-1.08/open_jtalk-1.08.tar.gz"
  sha1 "34749abce5f8263ebbe9843b92407f4f0a742c66"

  depends_on "gcc" => :build
  depends_on "hts-engine-api" => :build

  resource "voice" do
    url "http://downloads.sourceforge.net/project/open-jtalk/HTS%20voice/hts_voice_nitech_jp_atr503_m001-1.05/hts_voice_nitech_jp_atr503_m001-1.05.tar.gz"
    sha1 "4298eaef57f86b7c502488aad2f95963da75f061"
  end

  resource "mei" do
    url "http://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.4/MMDAgent_Example-1.4.zip"
    sha1 "8e94593244c636bbe757eb848f1025a0111f4372"
  end

  def install
    ENV['CC'] = "#{Formula["gcc"].opt_prefix}/bin/gcc-4.9"
    ENV['CXX'] = "#{Formula["gcc"].opt_prefix}/bin/g++-4.9"

    args = %W[
        --with-hts-engine-header-path=#{Formula["hts-engine-api"].opt_prefix}/include
        --with-hts-engine-library-path=#{Formula["hts-engine-api"].opt_prefix}/lib
        --with-charset=UTF-8
        --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    resource("voice").stage do
        mkdir_p "#{prefix}/voice/m100"
        cp_r Dir["*"], "#{prefix}/voice/m100"
    end
    resource("mei").stage do
        cp_r "Voice/mei", "#{prefix}/voice"
    end
  end

  test do
    system "echo おーぷんじぇいとーくのインストールがかんりょうしました > sample.txt"
    system bin/"open_jtalk",
        "-x", "#{prefix}/dic",
        "-m", "#{prefix}/voice/mei/mei_normal.htsvoice",
        "-ow", "out.wav",
        "sample.txt"
    system "afplay", "out.wav"
  end
end
