class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"
  url "https://github.com/n1k0/casperjs/archive/1.0.4.tar.gz"
  sha256 "d71b9dd77ac202f3fbb958f8876f12b89aee2a1b09b2c2c55fd11aa928a1fb1f"

  bottle do
    cellar :any
    sha256 "bc43ae16d5d8cd9e4f2a7e674c14c5323498fe95a3a8563649ecc9dad541767f" => :yosemite
    sha256 "872cda52831ac7591328e0829751a4a76674252f846a43cc45e9acb53ac7180e" => :mavericks
    sha256 "09690809c67e2f307ab1c7e10e29a08c639055bdbaedafa52420745d6e5022c8" => :mountain_lion
  end

  devel do
    url "https://github.com/n1k0/casperjs/archive/1.1-beta3.tar.gz"
    sha256 "bc286424fb52df6cf16cb9b8ef6534ee830bb8ab0b87d2625910d8c1824152dc"
    version "1.1-beta3"
  end

  head "https://github.com/n1k0/casperjs.git"

  # For embedded Phantomjs
  depends_on :macos => :snow_leopard

  # https://github.com/Homebrew/homebrew/pull/38632
  resource "phantomjs" do
    url "https://phantomjs.googlecode.com/files/phantomjs-1.8.2-macosx.zip"
    sha256 "7d19c1cce6c66bb3153d335522b4effe68ddd249f427776b82f2662fb5ed81cf"
  end

  def install
    libexec.install Dir["*"]
    (libexec/"phantomjs").install resource("phantomjs")

    (bin/"casperjs").write <<-EOS.undent
      #!/bin/bash
      export PATH=#{libexec}/phantomjs/bin:$PATH
      exec "#{libexec}/bin/casperjs" "$@"
    EOS
  end

  test do
    # Change this test when we're no longer embedding an old PhantomJS
    # It exists for now purely to make sure we're using the embedded PhantomJS.
    assert_match /version 1.8.2/, shell_output("#{bin}/casperjs")
  end
end
