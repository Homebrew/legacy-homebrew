class Lame < Formula
  desc "Lame Aint an MP3 Encoder (LAME)"
  homepage "http://lame.sourceforge.net/"
  url "https://downloads.sourceforge.net/sourceforge/lame/lame-3.99.5.tar.gz"
  sha256 "24346b4158e4af3bd9f2e194bb23eb473c75fb7377011523353196b19b9a23ff"

  bottle do
    cellar :any
    revision 1
    sha256 "fc7884b76f15e5feebef087b4597e1f142b9aed83274e989c1ca959edb294454" => :el_capitan
    sha1 "6e0b0c061c85bff64ac8359227d75133e6eb4234" => :yosemite
    sha1 "7ce12008e94a451c7564e6b966d9c088e4934082" => :mavericks
    sha1 "5e14b56d3bd8d6b93e8245bdf8ed4b01fd3899a3" => :mountain_lion
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
