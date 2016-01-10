class Casperjs < Formula
  desc "Navigation scripting and testing tool for PhantomJS"
  homepage "http://www.casperjs.org/"

  stable do
    url "https://github.com/n1k0/casperjs/archive/1.0.4.tar.gz"
    sha256 "d71b9dd77ac202f3fbb958f8876f12b89aee2a1b09b2c2c55fd11aa928a1fb1f"

    # https://github.com/Homebrew/homebrew/pull/38632
    # Once 1.1.x is stable combine all the PhantomJS resource into one.
    resource "phantomjs" do
      url "https://phantomjs.googlecode.com/files/phantomjs-1.8.2-macosx.zip"
      sha256 "7d19c1cce6c66bb3153d335522b4effe68ddd249f427776b82f2662fb5ed81cf"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a6f6140bcaceabae529d04ddeb152568575091e797b741be8e604e4030e31063" => :el_capitan
    sha256 "e4ad0b7e9f7c8b1a65142a5ac3a82e0adc7f571ba32192019898d0d854362ef5" => :yosemite
    sha256 "dc0297e379af5b10c3ef6e7d8ac00610adf7cb17bf8b1790a7d41b56a0e9692b" => :mavericks
    sha256 "fc20c22ec10d175d84bec4dd05d83fa8ea7fc78723a4e8d0f4041d5c00878651" => :mountain_lion
  end

  devel do
    url "https://github.com/n1k0/casperjs/archive/1.1-beta3.tar.gz"
    sha256 "bc286424fb52df6cf16cb9b8ef6534ee830bb8ab0b87d2625910d8c1824152dc"
    version "1.1-beta3"

    resource "phantomjs" do
      url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-macosx.zip"
      sha256 "8f15043ae3031815dc5f884ea6ffa053d365491b1bc0dc3a0862d5ff1ac20a48"
    end
  end

  head do
    url "https://github.com/n1k0/casperjs.git"

    resource "phantomjs" do
      url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-macosx.zip"
      sha256 "8f15043ae3031815dc5f884ea6ffa053d365491b1bc0dc3a0862d5ff1ac20a48"
    end
  end

  # For embedded Phantomjs
  depends_on :macos => :snow_leopard

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
    (testpath/"fetch.js").write <<-EOS.undent
      var casper = require("casper").create();
      casper.start("https://duckduckgo.com/about", function() {
        this.download("https://duckduckgo.com/assets/dax-alt.svg", "dax-alt.svg");
      });
      casper.run();
    EOS

    system bin/"casperjs", testpath/"fetch.js"
    assert File.exist?("dax-alt.svg")
  end
end
