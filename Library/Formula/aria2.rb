class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "http://aria2.sourceforge.net/"
  url "https://github.com/tatsuhiro-t/aria2/releases/download/release-1.19.1/aria2-1.19.1.tar.xz"
  sha256 "f731f64940ccfc78e8777190de354ba833fe248851b935d5d8885a7917fc101f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e114d3a0ff7905e5c43dd19b1b129ecb7c2854b20e829fa2c761dff6b5cb1e2f" => :el_capitan
    sha256 "42aa898093486f7a0978de60ec1d43bfee2d33996638a181340f7f9c9d275a70" => :yosemite
    sha256 "7735fb484cb3345f10c7ef44538aef12ba60cfc65de4940a419320e9360aba70" => :mavericks
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
