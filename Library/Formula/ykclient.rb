class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://yubico.github.io/yubico-c-client/"
  url "https://yubico.github.io/yubico-c-client/releases/ykclient-2.15.tar.gz"
  sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

  bottle do
    cellar :any
    sha256 "3ad851c0204662921e24aab8b473ba543cc63f84514e7d8eb65ea68a4a617a69" => :el_capitan
    sha256 "81b3de37e608406d52a02d5c56fcb2fa621af641e90e4985f4804d53dd41ef6e" => :yosemite
    sha256 "c051e1c30bc2cb34907e5d91e1addb572d2bfa2011c75e13c167712d93fefb47" => :mavericks
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
