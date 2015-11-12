class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://yubico.github.io/yubico-c-client/"
  url "https://yubico.github.io/yubico-c-client/releases/ykclient-2.15.tar.gz"
  sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

  bottle do
    cellar :any
    sha256 "a6bf94742e5dea65974107915a86ed3fdd97c4238279262fb6c49a153bf707da" => :yosemite
    sha256 "c80e5dbdd8e4790db32c09f7ec7ce542a1ecaa3d26818711ab1b1f4d9779b516" => :mavericks
    sha256 "1bc7d485b047e44cc7aca1530007f2480f36ddf26e1a4b5d55281ed587ade32c" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ykclient", "--version"
  end
end
