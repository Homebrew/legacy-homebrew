require "language/go"

class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "http://nsq.io"
  url "https://github.com/nsqio/nsq/archive/v0.3.7.tar.gz"
  sha256 "fb71e28c757dd485b43b9bc75d90eb44ff9166ccb3d8a928c5e655b483da316e"
  revision 1

  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b74e0f20554251ea1060d4f306770fa658378a9dad34851675f12c15226fb0e" => :el_capitan
    sha256 "686768ca33222259e4eae655de601119da6621fc10c8a8d30ffa27d7736298f8" => :yosemite
    sha256 "6829fc7d9d4de5a5ff5ef5629e7f9e41919193436ce9f82159f34e33d4983c59" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "2dff11163ee667d51dcc066660925a92ce138deb"
  end

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git",
      :revision => "58b95b10d6ca26723a7f46017b348653b825a8d6"
  end

  go_resource "github.com/nsqio/go-nsq" do
    url "https://github.com/nsqio/go-nsq.git",
      :revision => "cef6982c1150617a77539847950ca63774f0e48c"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
      :revision => "18db6e68d8fd9cbf2e8ebe4c81a78b96fd9bf05a"
  end

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
      :revision => "6cb9d9d729303ee2628580d9aec5db968da3a607"
  end

  go_resource "github.com/mreiferson/go-options" do
    url "https://github.com/mreiferson/go-options.git",
      :revision => "2cf7eb1fdd83e2bb3375fef6fdadb04c3ad564da"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
      :revision => "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504"
  end

  go_resource "github.com/bitly/timer_metrics" do
    url "https://github.com/bitly/timer_metrics.git",
      :revision => "afad1794bb13e2a094720aeb27c088aa64564895"
  end

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
      :revision => "9bf7bff48b0388cb75991e58c6df7d13e982f1f2"
  end

  go_resource "github.com/julienschmidt/httprouter" do
    url "https://github.com/julienschmidt/httprouter.git",
      :revision => "6aacfd5ab513e34f7e64ea9627ab9670371b34e7"
  end

  go_resource "github.com/judwhite/go-svc" do
    url "https://github.com/judwhite/go-svc.git",
      :revision => "53bd3020e68399b23994ce23d1130801aa674226"
  end

  def install
    # build a proper GOPATH tree for local dependencies
    (buildpath + "src/github.com/nsqio/nsq").install "Makefile", "apps", "internal", "nsqlookupd", "nsqd", "nsqadmin"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/github.com/nsqio/nsq" do
      system "make"
      system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
    end
  end

  test do
    begin
      lookupd = fork do
        exec bin/"nsqlookupd"
      end
      sleep 2
      d = fork do
        exec bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
      end
      sleep 2
      admin = fork do
        exec bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
      end
      sleep 2
      to_file = fork do
        exec bin/"nsq_to_file", "--topic=test", "--output-dir=#{testpath}",
               "--lookupd-http-address=127.0.0.1:4161"
      end
      sleep 2
      system "curl", "-d", "hello", "http://127.0.0.1:4151/put?topic=test"

      dat = File.read(Dir["*.dat"].first)
      assert_match "test", dat
      assert_match version.to_s, dat
    ensure
      Process.kill(9, lookupd)
      Process.kill(9, d)
      Process.kill(9, admin)
      Process.kill(9, to_file)
      Process.wait lookupd
      Process.wait d
      Process.wait admin
      Process.wait to_file
    end
  end
end
