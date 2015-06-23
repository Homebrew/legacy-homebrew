require "language/go"

class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.82.tar.gz"
  sha256 "b64a6367445b707ae272ff917d971133777f62893f75a3dbaa0a19018d02a51c"
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any
    sha256 "12ddd4206dba15312852a8347a2111443be58f0528a0bda43a740d6877999144" => :yosemite
    sha256 "52fd76910fb29f1a266e0e26dbec4661ef1473dfd8eef58d4f0d6e881c6e01c9" => :mavericks
    sha256 "411ea5a35dd634e2888eb4786fa7e40a198d77b21f3b1ea8669141e20e3f50bd" => :mountain_lion
  end

  depends_on "readline"
  depends_on "go" => :build

  # List of Go dependencies and hashes.
  # Generated using: https://github.com/samertm/homebrew-go-resources
  %w[
    github.com/bkaradzic/go-lz4 4f7c2045dbd17b802370e2e6022200468abf02ba
    github.com/bobappleyard/readline a1f23ef6d7c8177f1fe3085d3bf7b40457049f0c
    github.com/boltdb/bolt 5eb31d5821750fbc84284d610c0ce85261662adb
    github.com/bradfitz/http2 f8202bc903bda493ebba4aa54922d78430c2c42f
    github.com/didip/tollbooth 92eb90f4dfa13cf8e2d2d7d120da6c3ff4d7f695
    github.com/eknkc/amber ee5a5b8364bb73899fdd529d23af6ad9230f8a06
    github.com/fatih/color 1b35f289c47d5c73c398cea8e006b7bcb6234a96
    github.com/garyburd/redigo 3e4727f0ef5938d3a846cdb57e560dba4419e854
    github.com/getwe/figlet4go accc26b01fe9ddb12c1b2ce19c2212551d70af87
    github.com/go-fsnotify/fsnotify 6549b98005f3e4026ad9f50ef7d5011f40ba1397
    github.com/go-sql-driver/mysql 66b7d5c4956096efd4c945494d64ad73f1d9ec39
    github.com/juju/ratelimit faa59ce93750e747b2997635e8b7daf30024b1ac
    github.com/mamaar/risotto 2683127f39af835e766a70b203efc6a51dd2ebe6
    github.com/mattn/go-runewidth 5890272cd41c5103531cd7b79e428d99c9e97f76
    github.com/mitchellh/go-homedir 1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4
    github.com/mitchellh/mapstructure 2caf8efc93669b6c43e0441cdc6aed17546c96f3
    github.com/natefinch/pie 0e26844fad24d1f3fc81b7d6a8f8589cac6ec64c
    github.com/nsf/termbox-go 598cdb8b3c49430c1c91604805461732064bde1d
    github.com/russross/blackfriday 386ef80f18233ea97960e855a54382ec446c6637
    github.com/shiena/ansicolor 8368d3b31cf6f2c2464c7a91675342c9a0ac6658
    github.com/shurcooL/sanitized_anchor_name 11a20b799bf22a02808c862eb6ca09f7fb38f84a
    github.com/sirupsen/logrus 0f2a4955b11372eec5a4b95d907eaf8379b835d0
    github.com/tylerb/graceful ac9ebe4f1ee151ac1eeeaef32957085cba64d508
    github.com/xyproto/cookie b84c85ae2aa3e21b2c7fc8c37d5a3081c0c9c83b
    github.com/xyproto/jpath 7b9116746a7134fdcefd5802af406361087bb190
    github.com/xyproto/mime 58d5c367ee5b5e10f4662848579b8ccd759b280e
    github.com/xyproto/permissionbolt b94c45a7f4c70603f12aa1d47a325a37036fd3ba
    github.com/xyproto/permissions2 b5248dea92e87c670813edf4e68dc16eff59c05b
    github.com/xyproto/permissionsql af2b7c0135a89a396d8486d71821eaa10f5cb62d
    github.com/xyproto/pinterface d4db92ac11a07dc77faece6d5ec7d64492958f2a
    github.com/xyproto/recwatch 3c0912279ade9b2d2a2a9c07cfbd41d7f5974393
    github.com/xyproto/simplebolt d8607225ae1d5735a2153918307c2ebc2e38d899
    github.com/xyproto/simplemaria 80759a73a6b576479bbf2baf955f7a46e04cb5b5
    github.com/xyproto/simpleredis 97bd090877ec34e2eebb75a547eaab25bf92dee4
    github.com/xyproto/term c9eabb15c0681f48654ee132a8bc6608c7bed8b3
    github.com/xyproto/unzip 823950573952ff86553b26381fe7472549873cb4
    github.com/yosssi/gcss 39677598ea4f3ec1da5568173b4d43611f307edb
    github.com/yuin/gluamapper d836955830e75240d46ce9f0e6d148d94f2e1d3a
    github.com/yuin/gopher-lua 54750d6aec1c2706990e9ec17438bd88d30231ab
  ].each_slice(2) do |resurl, rev|
    go_resource resurl do
      url "https://#{resurl}.git", :revision => rev
    end
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "4ed45ec682102c643324fae5dff8dab085b6c300"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "dfe268fd2bb5c793f4c083803609fce9806c6f80"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "algernon"

    bin.install "algernon"
  end

  test do
    begin
      tempdb = "/tmp/_brew_test.db"
      cport = ":45678"

      # Start the server in a fork
      algernon_pid = fork do
        exec "#{bin}/algernon", "--quiet", "--httponly", "--server", "--addr", cport
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      output = `curl -sIm3 -o- http://localhost#{cport}`
      assert output.include?("Server: Algernon")
      assert_equal 0, $?.exitstatus

    ensure
      # Stop the server gracefully
      Process.kill("HUP", algernon_pid)

      # Remove temporary Bolt database
      rm_f tempdb
    end
  end
end
