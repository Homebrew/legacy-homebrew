require "language/go"

class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.85.tar.gz"
  sha256 "c30380d9781166a6cc6297210e70c742c5a6c91bbbbdbf223783db1ffa1aa7e6"
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "4afae3ee47dc003a6916c399b103dd8d8223db6c2234ba4a3a67f9e52e338efd" => :el_capitan
    sha256 "aa0512e558bd8179c0c09149dee8eb6460f8f89518f18bfb240c6c28d159d5bd" => :yosemite
    sha256 "eb6c1a3760fb5ba8257aef23c04837b511e86d61b1b9bd3e443b760f01ab6d6a" => :mavericks
  end

  depends_on "readline"
  depends_on "go" => :build

  # List of Go dependencies and hashes.
  # Generated using: https://github.com/samertm/homebrew-go-resources
  %w[
    github.com/bobappleyard/readline 7e300e02d38ee8b418c0b4841877f1845d392328
    github.com/boltdb/bolt 033d4ec028192f38aef67ae47bd7b89f343145b5
    github.com/bradfitz/http2 f8202bc903bda493ebba4aa54922d78430c2c42f
    github.com/didip/tollbooth 7b2c2552bf39929bd6de1aa9d2b3aa1deae83035
    github.com/eknkc/amber 144da19a9994994c069f0693294a66dd310e14a4
    github.com/fatih/color 76d423163af754ff6423d2d9be0057fbf03c57c2
    github.com/garyburd/redigo d8dbe4d94f15fe89232e0402c6e8a0ddf21af3ab
    github.com/getwe/figlet4go accc26b01fe9ddb12c1b2ce19c2212551d70af87
    github.com/go-fsnotify/fsnotify 6549b98005f3e4026ad9f50ef7d5011f40ba1397
    github.com/go-sql-driver/mysql 527bcd55aab2e53314f1a150922560174b493034
    github.com/juju/ratelimit 772f5c38e468398c4511514f4f6aa9a4185bc0a0
    github.com/klauspost/compress c1066ab291ad75d95c5e46d5e309e80bbcf42928
    github.com/klauspost/cpuid c9fd3fcd8d33cb370087cac58108ce1e5578440d
    github.com/klauspost/crc32 a5d1ea1c7bb4ad05a27df06491071dd6d45d1a08
    github.com/klauspost/pgzip 346e6916b563ae7b6a811ab57ec5a881e659fca3
    github.com/mamaar/risotto 2683127f39af835e766a70b203efc6a51dd2ebe6
    github.com/mattn/go-isatty 7fcbc72f853b92b5720db4a6b8482be612daef24
    github.com/mattn/go-runewidth 12e0ff74603c9a3209d8bf84f8ab349fe1ad9477
    github.com/mitchellh/go-homedir df55a15e5ce646808815381b3db47a8c66ea62f4
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/natefinch/pie 83bfd1821ee0ba96a47d98cbed424313fb60f57a
    github.com/nsf/termbox-go 9914d1c528437633580e9aeda764bfb8c1415a9a
    github.com/russross/blackfriday 8cec3a854e68dba10faabbe31c089abf4a3e57a6
    github.com/shiena/ansicolor a5e2b567a4dd6cc74545b8a4f27c9d63b9e7735b
    github.com/shurcooL/sanitized_anchor_name 244f5ac324cb97e1987ef901a0081a77bfd8e845
    github.com/sirupsen/logrus 418b41d23a1bf978c06faea5313ba194650ac088
    github.com/tylerb/graceful ac9ebe4f1ee151ac1eeeaef32957085cba64d508
    github.com/xyproto/cookie b84c85ae2aa3e21b2c7fc8c37d5a3081c0c9c83b
    github.com/xyproto/jpath d9213e11ca293e9e2705217ed372f53467d079ab
    github.com/xyproto/mime 58d5c367ee5b5e10f4662848579b8ccd759b280e
    github.com/xyproto/permissionbolt 0171a7ac74f66f5116a4c480b634fe952893520b
    github.com/xyproto/permissions2 e7bc1222c82ea982fdf175aa16053a9a2f6ef32e
    github.com/xyproto/permissionsql af2b7c0135a89a396d8486d71821eaa10f5cb62d
    github.com/xyproto/pinterface d4db92ac11a07dc77faece6d5ec7d64492958f2a
    github.com/xyproto/recwatch 3c0912279ade9b2d2a2a9c07cfbd41d7f5974393
    github.com/xyproto/simplebolt d8607225ae1d5735a2153918307c2ebc2e38d899
    github.com/xyproto/simplemaria 80759a73a6b576479bbf2baf955f7a46e04cb5b5
    github.com/xyproto/simpleredis de7b4cb9d1be983af7e9924394a27b67927e4918
    github.com/xyproto/term 1861114eab54d24594e33fc87d63457cef67e24e
    github.com/xyproto/unzip 823950573952ff86553b26381fe7472549873cb4
    github.com/yosssi/gcss 39677598ea4f3ec1da5568173b4d43611f307edb
    github.com/yuin/gluamapper d836955830e75240d46ce9f0e6d148d94f2e1d3a
    github.com/yuin/gopher-lua abbdcf090159c9ef292a99e8049fb2567bc24c31
  ].each_slice(2) do |resurl, rev|
    go_resource resurl do
      url "https://#{resurl}.git", :revision => rev
    end
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "aedad9a179ec1ea11b7064c57cbc6dc30d7724ec"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "db8e4de5b2d6653f66aea53094624468caad15d2"
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
        exec "#{bin}/algernon", "--quiet", "--httponly", "--server", "--boltdb", tempdb, "--addr", cport
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      output = `curl -sIm3 -o- http://localhost#{cport}`
      assert_match /^Server: Algernon/, output
      assert_equal 0, $?.exitstatus

    ensure
      # Stop the server gracefully
      Process.kill("HUP", algernon_pid)

      # Remove temporary Bolt database
      rm_f tempdb
    end
  end
end
