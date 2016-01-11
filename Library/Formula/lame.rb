class Lame < Formula
  desc "Lame Aint an MP3 Encoder (LAME)"
  homepage "http://lame.sourceforge.net/"
  url "https://downloads.sourceforge.net/sourceforge/lame/lame-3.99.5.tar.gz"
  sha256 "24346b4158e4af3bd9f2e194bb23eb473c75fb7377011523353196b19b9a23ff"

  bottle do
    cellar :any
    revision 1
    sha256 "fc7884b76f15e5feebef087b4597e1f142b9aed83274e989c1ca959edb294454" => :el_capitan
    sha256 "064e13206ca4f731d919f89adb480b4a83116a4374f5aa6d205528838364ca7b" => :yosemite
    sha256 "43ee3550ab5ce2c5e9b4e8adfedc197b5ffbf252320d46de97cd6a7133ddd16f" => :mavericks
    sha256 "db743baefa0ec1b0f8c00df4728536418916c4d42c71c548dc43d43a1b24b523" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end

  test do
    system "#{bin}/lame", "--genre-list", test_fixtures("test.mp3")
  end
end
