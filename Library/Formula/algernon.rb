require "language/go"

class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.87.tar.gz"
  sha256 "5179e0f5f0ce7f21e7de6dc467bbcb6b986b325ce3c2ae0d6e75795c73bfd3c3"

  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "b8ea8fd8bcdb5b81df88d79e8a16f931f90b6b9a0c4a3221d288ad77876cb689" => :el_capitan
    sha256 "16918d822d182c48e4ea852a2146419fa33a5a067fd63b2e898c9b0ab1824863" => :yosemite
    sha256 "5b534dc90ef2b2374e0afd13ee160a912bb68b6cf5cbc046cebe13c5d636b677" => :mavericks
  end

  depends_on "go" => :build
  depends_on "readline"

  # List of Go dependencies and hashes.
  # Generated using: https://github.com/samertm/homebrew-go-resources
  %w[
    github.com/bobappleyard/readline 7e300e02d38ee8b418c0b4841877f1845d392328
    github.com/boltdb/bolt b514920f8f2e0a68f857e5a12c774f385a59aef9
    github.com/bradfitz/http2 aa7658c0e9902e929a9ed0996ef949e59fc0f3ab
    github.com/didip/tollbooth be7d4891cc860c1d3d4004e99b898ddfd419ceb1
    github.com/eknkc/amber 144da19a9994994c069f0693294a66dd310e14a4
    github.com/fatih/color 4f7bcef27eec7925456d0c30c5e7b0408b3339be
    github.com/fsnotify/fsnotify 3c39c22b2c7b0516d5f2553f1608e5d13cb19053
    github.com/garyburd/redigo 4ed1111375cbeb698249ffe48dd463e9b0a63a7a
    github.com/getwe/figlet4go accc26b01fe9ddb12c1b2ce19c2212551d70af87
    github.com/go-sql-driver/mysql 0f2db9e6c9cff80a97ca5c2c5096242cc1554e16
    github.com/juju/ratelimit 77ed1c8a01217656d2080ad51981f6e99adaa177
    github.com/klauspost/compress 2d3d403f37d2e70b722590bc286076a17422e1f2
    github.com/klauspost/cpuid 09cded8978dc9e80714c4d85b0322337b0a1e5e0
    github.com/klauspost/crc32 19b0b332c9e4516a6370a0456e6182c3b5036720
    github.com/klauspost/pgzip 95e8170c5d4da28db9c64dfc9ec3138ea4466fd4
    github.com/mamaar/risotto c3b4f4dbac6541f11ed5bc1b97d00ef06bbe34c0
    github.com/mattn/go-runewidth d037b52ae5c0338c2bb18da01fb7ddf0e8be9aa1
    github.com/mitchellh/go-homedir 981ab348d865cf048eb7d17e78ac7192632d8415
    github.com/mitchellh/mapstructure d2dd0262208475919e1a362f675cfc0e7c10e905
    github.com/natefinch/pie 6059396cf8c679e5b6a7c82378e4623ca62f91ff
    github.com/nsf/termbox-go 362329b0aa6447eadd52edd8d660ec1dff470295
    github.com/russross/blackfriday 006144af03eeeff1037240a71865a9fd61f1c25f
    github.com/shurcooL/sanitized_anchor_name 10ef21a441db47d8b13ebcc5fd2310f636973c77
    github.com/sirupsen/logrus 219c8cb75c258c552e999735be6df753ffc7afdc
    github.com/tylerb/graceful c78c8d9dded2ad16ad81b1fa526a81b2bb8049f6
    github.com/xyproto/cookie b84c85ae2aa3e21b2c7fc8c37d5a3081c0c9c83b
    github.com/xyproto/jpath d9213e11ca293e9e2705217ed372f53467d079ab
    github.com/xyproto/mime 58d5c367ee5b5e10f4662848579b8ccd759b280e
    github.com/xyproto/permissionbolt 45c93aae7044f5ed912843437557c86b15463975
    github.com/xyproto/permissions2 67cea239db53332cce94945251b9c70e49c35769
    github.com/xyproto/permissionsql 282767a73a87a51428c00b4b9bf92590cf7fa163
    github.com/xyproto/pinterface d4db92ac11a07dc77faece6d5ec7d64492958f2a
    github.com/xyproto/pongo2 6784189431019a8b8fb874cb4b30ee36789e7892
    github.com/xyproto/recwatch eec3775073f11929973b0d06507a682f8061babb
    github.com/xyproto/simplebolt 736018229d5a2972820bc9d6a8c5a6b0ba6fadc3
    github.com/xyproto/simplemaria 80759a73a6b576479bbf2baf955f7a46e04cb5b5
    github.com/xyproto/simpleredis de7b4cb9d1be983af7e9924394a27b67927e4918
    github.com/xyproto/term 1861114eab54d24594e33fc87d63457cef67e24e
    github.com/xyproto/unzip 823950573952ff86553b26381fe7472549873cb4
    github.com/yosssi/gcss 39677598ea4f3ec1da5568173b4d43611f307edb
    github.com/yuin/gluamapper d836955830e75240d46ce9f0e6d148d94f2e1d3a
    github.com/yuin/gopher-lua e5faab4db06a81efb60d8e16c1d205e1d93736a9
  ].each_slice(2) do |resurl, rev|
    go_resource resurl do
      url "https://#{resurl}.git", :revision => rev
    end
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "5dc8cb4b8a8eb076cbb5a06bc3b8682c15bdbbd3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "3e5cd1ed149001198e582f9d3f5bfd564cde2896"
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
