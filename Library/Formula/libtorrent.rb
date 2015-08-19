class Libtorrent < Formula
  desc "BitTorrent library"
  homepage "https://github.com/rakshasa/libtorrent"
  # Both homepage and primary url have been down since at least ~April 2015
  # https://github.com/rakshasa/rtorrent/issues/295
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libt/libtorrent/libtorrent_0.13.4.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libt/libtorrent/libtorrent_0.13.4.orig.tar.gz"
  sha256 "74a193d0e91a26f9471c12424596e03b82413d0dd0e1c8d4d7dad25a01cc60e5"

  def pour_bottle?
    # https://github.com/Homebrew/homebrew/commit/5eb5e4499c9
    false
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  # https://github.com/Homebrew/homebrew/issues/24132
  fails_with :clang do
    cause "Causes segfaults at startup/at random."
  end

  def install
    # Currently can't build against libc++; see:
    # https://github.com/homebrew/homebrew/issues/23483
    # https://github.com/rakshasa/libtorrent/issues/47
    ENV.libstdcxx if ENV.compiler == :clang

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-kqueue",
                          "--enable-ipv6"
    system "make"
    system "make", "install"
  end
end
