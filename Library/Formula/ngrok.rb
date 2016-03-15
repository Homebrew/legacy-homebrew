# Please don't update this formula to the 2.x releases until those are
# open-source and available to build from source. Ref:
# https://github.com/Homebrew/homebrew/pull/45441
class Ngrok < Formula
  desc "Expose localhost to the internet and capture traffic for replay"
  homepage "https://ngrok.com"
  url "https://github.com/inconshreveable/ngrok/archive/1.7.1.tar.gz"
  sha256 "ffb1ad90d5aa3c8b3a9bfd8109a71027645a78d5e61fccedd0873fee060da665"
  revision 1

  head "https://github.com/inconshreveable/ngrok.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "56c524adac0a24f47400d369a330cfd55d4d46d04067296dc9bd18cf71180451" => :el_capitan
    sha256 "48d055cb8bb673f5b4e48d80c76e2b59b6d5aae92bf7e1b3015f44c98fe42e1f" => :yosemite
    sha256 "2c72dde1ebeb190c5d81bac44d66f98e11486a8f761ac73f796e798863cbfd35" => :mavericks
  end

  depends_on "go" => :build
  depends_on :hg => :build

  patch do
    url "https://github.com/inconshreveable/ngrok/commit/761e6d0de87f4175b91a007951d7ca4ab12b7d04.diff"
    sha256 "1bfc6342e1c194a7763039de8d6a1a1c3783a30f0517473248e0fccb3c71c211"
  end

  def install
    ENV.j1
    system "make", "release-client"
    bin.install "bin/ngrok"
  end

  test do
    system "#{bin}/ngrok", "version"
  end
end
