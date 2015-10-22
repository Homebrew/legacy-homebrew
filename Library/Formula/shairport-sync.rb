class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.6.tar.gz"
  sha256 "d04036241e5a811240c43a3ddfb05a119a6043e8c5f1f354872a88e6cbdaef07"
  head "https://github.com/mikebrady/shairport-sync.git"

  bottle do
    sha256 "a97e873dc066b75114dec9d8ac929a9e882baaa4ec92f9df8b883f906cc2e24d" => :el_capitan
    sha256 "961094f0cc116f3da6b42279e0011951f5d9533a8ffea924286bc08b9e384ac3" => :yosemite
    sha256 "de98889a8902489520b8e8148fd76f8e65379f7ea980735fdc383dddd612155f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "popt"
  depends_on "libsoxr"
  depends_on "libao"
  depends_on "libdaemon"
  depends_on "libconfig"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os-type=darwin
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-soxr
      --with-configfiles=no
      --with-piddir=#{prefix}
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    test_cmd = "#{bin}/shairport-sync -V"
    assert_match(/openssl-ao-soxr/, shell_output(test_cmd, 1))
  end
end
