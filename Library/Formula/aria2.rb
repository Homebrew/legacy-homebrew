class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "http://aria2.sourceforge.net/"
  url "https://github.com/tatsuhiro-t/aria2/releases/download/release-1.19.3/aria2-1.19.3.tar.xz"
  sha256 "6abcc6c28437a519cc1016736cb446ed38db360cb9828c4a7105526ea82299e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f86ad9fe0a36da39d9b92bfd13328f4be449f3b2ee8481a3ae1aa4563b478f4" => :el_capitan
    sha256 "150f486de66ff284ab7491e22d9cc1b4b841904052d65b20a0b36af9833d7b45" => :yosemite
    sha256 "40ce69ef73400de2cb5c2005b98bec28d4bcb64241eef3dbb548cef53b5ae20c" => :mavericks
  end

  depends_on "pkg-config" => :build

  needs :cxx11

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist? "index.html"
  end
end
