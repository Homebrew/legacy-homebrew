class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/archive/v0.5.2.tar.gz"
  sha256 "e7735e503f894f19b5a3717c085aa9f6f18702696de91f17bd5405f95f8d6f98"

  bottle do
    cellar :any
    sha256 "3ffa5aa7fc7d1a032e2e34f3f6c697b8ac6a2092cf8ab55c9573571259bff8b8" => :el_capitan
    sha256 "efffe5780c33906a1f99950ee44a23414f742ce1c004435abe80650abd7f2c8d" => :yosemite
    sha256 "5b995f1bc1ab144c0df6b97b0bd7f659ed95e584f3cedf26304ccbc3ac7de7f7" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
