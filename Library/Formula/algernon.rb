require "language/go"

class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.84.tar.gz"
  sha256 "bc6c9899744ae50736dee1cea1e6c3228d89f8ccf436eb22694664b828e927fc"
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any
    sha256 "4ebddb2a0305b89d5b266412f4b25174ad60fff9032a97f64d45e9f2aad86bb7" => :yosemite
    sha256 "81b3ea73e9a7cae9cee08b02db3d3029d2340335b5b8957dcd128eb93246c906" => :mavericks
    sha256 "4d6aaf877dd6f8d5606d076f39ebc1d93998ccaba26f683b998525e730449ccb" => :mountain_lion
  end

  depends_on "readline"
  depends_on "go" => :build

  # List of Go dependencies and hashes.
  # Generated using: https://github.com/samertm/homebrew-go-resources
  %w[
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
    github.com/klauspost/pgzip 49eeca5953c2a6c7be4e34e8803029e6354d9bb7
    github.com/mamaar/risotto 2683127f39af835e766a70b203efc6a51dd2ebe6
    github.com/mattn/go-runewidth 5890272cd41c5103531cd7b79e428d99c9e97f76
    github.com/mitchellh/go-homedir 1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4
    github.com/mitchellh/mapstructure 2caf8efc93669b6c43e0441cdc6aed17546c96f3
    github.com/natefinch/pie 83bfd1821ee0ba96a47d98cbed424313fb60f57a
    github.com/nsf/termbox-go 675ffd907b7401b8a709a5ef2249978af5616bb2
    github.com/russross/blackfriday 386ef80f18233ea97960e855a54382ec446c6637
    github.com/shiena/ansicolor 23296fbcefa1c43b2151a2c65812b71b85cf9f9b
    github.com/shurcooL/sanitized_anchor_name 11a20b799bf22a02808c862eb6ca09f7fb38f84a
    github.com/sirupsen/logrus d3e4ea403263d5e349c43ba8309e81f820325393
    github.com/tylerb/graceful ac9ebe4f1ee151ac1eeeaef32957085cba64d508
    github.com/xyproto/cookie b84c85ae2aa3e21b2c7fc8c37d5a3081c0c9c83b
    github.com/xyproto/jpath d9213e11ca293e9e2705217ed372f53467d079ab
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

      # Start the server in a fork and retrieve the PID
      algernon_pid = fork do
        exec "#{bin}/algernon", "--quiet", "--httponly", "--server", "--boltdb", tempdb, "--addr", cport
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
