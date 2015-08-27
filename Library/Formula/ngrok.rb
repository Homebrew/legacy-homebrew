class Ngrok < Formula
  desc "Expose localhost to the internet and capture traffic for replay"
  homepage "https://ngrok.com"
  head "https://github.com/inconshreveable/ngrok.git"
  url "https://github.com/inconshreveable/ngrok/archive/1.7.1.tar.gz"
  sha256 "ffb1ad90d5aa3c8b3a9bfd8109a71027645a78d5e61fccedd0873fee060da665"

  bottle do
    sha1 "71920267073415ccc1ea1305bac6ce51e00d4833" => :mavericks
    sha1 "e0a622225d38ee57652b84eaffbca95ab43c3ce2" => :mountain_lion
    sha1 "60b7a16a28265e6e9a9adbac44b3c5069a802d34" => :lion
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
