require "language/go"

class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "http://nsq.io"
  url "https://github.com/bitly/nsq/archive/v0.3.5.tar.gz"
  sha256 "4120ad24e3700be1e65549b9a55eab5d4e744cd114d9b39779a47b6dedda0b35"

  head "https://github.com/bitly/nsq.git"

  bottle do
    cellar :any
    sha256 "eb9dd459eec6603dd720b58b8fcee5ccfc122999aed51845ff2c98e0bb3fabfe" => :yosemite
    sha256 "b17656e4e8b93abf9d6b0b65b614ffa7fecc2b0920a8d0329aa6abda2e5a2f7e" => :mavericks
    sha256 "dd00b16b6708fd69764ec0276568f88b4d3c8729c6be45859b3450b313a0f3b6" => :mountain_lion
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

  go_resource "github.com/bitly/go-nsq" do
    url "https://github.com/bitly/go-nsq.git",
      :revision => "22a8bd48c443ec23bb559675b6df8284bbbdab29"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
      :revision => "fc395a5db941cf38922b1ccbc083640cd76fe4bc"
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

  def install
    # build a proper GOPATH tree for local dependencies
    (buildpath + "src/github.com/bitly/nsq").install "internal", "nsqlookupd", "nsqd", "nsqadmin"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
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
