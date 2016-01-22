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
    sha256 "d8f9bdc6d070a69446eda8a0851192171e9f498a23d30f1bca8f5dc0582ad774" => :el_capitan
    sha256 "4badc8538de923967d34ef0548ec9539b10efc65b07edf4ace1a1ccbe8a94d4a" => :yosemite
    sha256 "b93d622f31fab29567c6fa1f26d2c2d2ba50b3d443fcaa94b02bea7194a4764e" => :mavericks
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV.j1
    system "make", "release-client"
    bin.install "bin/ngrok"
  end

  test do
    system "#{bin}/ngrok", "version"
  end
end
