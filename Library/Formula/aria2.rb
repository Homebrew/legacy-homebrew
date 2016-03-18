class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "http://aria2.sourceforge.net/"
  url "https://github.com/tatsuhiro-t/aria2/releases/download/release-1.21.0/aria2-1.21.0.tar.xz"
  sha256 "225c5f2c8acc899e0a802cdf198f82bd0d3282218e80cdce251b1f9ffacf6580"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6238cde6d6cdec0d8ced8cd97760b897bffda6d8d856d45dfa169bd358ac001" => :el_capitan
    sha256 "2d0cf115454f179349bd7e540cb89faae0fcd8cb8e9f270888e4b743a51adf9b" => :yosemite
    sha256 "0d8e36764f00d0068deabe5976f140cc3085e8f9627cd3719764225fec277429" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

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

    args << "--with-libssh2" if build.with? "libssh2"

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist? "index.html"
  end
end
