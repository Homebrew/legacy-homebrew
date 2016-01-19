require "language/go"

class Algernon < Formula
  desc "HTTP/2 web server with Lua support"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/0.86.tar.gz"
  sha256 "f7d283a40b0f71c209d854570214f9b96f3e8e7036402e770e2aa8e93a40ffe3"
  revision 1

  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "aa1219f964811b531af0242258c162b6f6079de787caad3445cae3995b96f865" => :el_capitan
    sha256 "c7482a0fc6ee1f2c4f5a711495451e035b9204c43466af5e0698cb1d600e68ae" => :yosemite
    sha256 "b110de259d2b89dc635073ec4810e312c04fc6969ed21d6ae5d3efe834dc2b79" => :mavericks
  end

  depends_on "go" => :build
  depends_on "readline"

  # List of Go dependencies and hashes.
  # Generated using: https://github.com/samertm/homebrew-go-resources
  %w[
    github.com/bobappleyard/readline 7e300e02d38ee8b418c0b4841877f1845d392328
    github.com/boltdb/bolt 0b00effdd7a8270ebd91c24297e51643e370dd52
    github.com/bradfitz/http2 6608b73ef18668469ee5365431dc3a106502c449
    github.com/didip/tollbooth be7d4891cc860c1d3d4004e99b898ddfd419ceb1
    github.com/eknkc/amber 144da19a9994994c069f0693294a66dd310e14a4
    github.com/fatih/color 9aae6aaa22315390f03959adca2c4d395b02fcef
    github.com/garyburd/redigo 6ece6e0a09f28cc399b21550cbf37ab39ba63cce
    github.com/getwe/figlet4go accc26b01fe9ddb12c1b2ce19c2212551d70af87
    github.com/go-fsnotify/fsnotify 7be54206639f256967dd82fa767397ba5f8f48f5
    github.com/go-sql-driver/mysql d512f204a577a4ab037a1816604c48c9c13210be
    github.com/juju/ratelimit 772f5c38e468398c4511514f4f6aa9a4185bc0a0
    github.com/klauspost/compress eb073746a16efe36368ed26c1713412cde1d8937
    github.com/klauspost/cpuid 8d9fe9648674c9699346aa4a5456cc9e1c0a96db
    github.com/klauspost/crc32 3e5c38b8b170916b332a5ccb25f921314b98ba01
    github.com/klauspost/pgzip 1e7ece2286a27cc064628f39fda30a48d818d985
    github.com/mamaar/risotto 2683127f39af835e766a70b203efc6a51dd2ebe6
    github.com/mattn/go-colorable 51a7e7a8b1665b25ca173debdc8d52d493348f15
    github.com/mattn/go-isatty d6aaa2f596ae91a0a58d8e7f2c79670991468e4f
    github.com/mattn/go-runewidth 12e0ff74603c9a3209d8bf84f8ab349fe1ad9477
    github.com/mitchellh/go-homedir d682a8f0cf139663a984ff12528da460ca963de9
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/natefinch/pie 83bfd1821ee0ba96a47d98cbed424313fb60f57a
    github.com/nsf/termbox-go da190e1fe57cb6bc60a3d9d407533d944c7c450d
    github.com/russross/blackfriday 300106c228d52c8941d4b3de6054a6062a86dda3
    github.com/shurcooL/sanitized_anchor_name 10ef21a441db47d8b13ebcc5fd2310f636973c77
    github.com/sirupsen/logrus a22723f16efea2e89b7bd67d10ed077c47c14eb4
    github.com/tylerb/graceful 48afeb21e2fcbcff0f30bd5ad6b97747b0fae38e
    github.com/xyproto/cookie b84c85ae2aa3e21b2c7fc8c37d5a3081c0c9c83b
    github.com/xyproto/jpath d9213e11ca293e9e2705217ed372f53467d079ab
    github.com/xyproto/mime 58d5c367ee5b5e10f4662848579b8ccd759b280e
    github.com/xyproto/permissionbolt 2df26b1551692e16594f818198969bde279caaec
    github.com/xyproto/permissions2 cda148f601f8366aed9ce00669ecd700999a1501
    github.com/xyproto/permissionsql af2b7c0135a89a396d8486d71821eaa10f5cb62d
    github.com/xyproto/pinterface d4db92ac11a07dc77faece6d5ec7d64492958f2a
    github.com/xyproto/recwatch 3c0912279ade9b2d2a2a9c07cfbd41d7f5974393
    github.com/xyproto/simplebolt 736018229d5a2972820bc9d6a8c5a6b0ba6fadc3
    github.com/xyproto/simplemaria 80759a73a6b576479bbf2baf955f7a46e04cb5b5
    github.com/xyproto/simpleredis de7b4cb9d1be983af7e9924394a27b67927e4918
    github.com/xyproto/term 1861114eab54d24594e33fc87d63457cef67e24e
    github.com/xyproto/unzip 823950573952ff86553b26381fe7472549873cb4
    github.com/yosssi/gcss 39677598ea4f3ec1da5568173b4d43611f307edb
    github.com/yuin/gluamapper d836955830e75240d46ce9f0e6d148d94f2e1d3a
    github.com/yuin/gopher-lua f918613776713b6f81c708f3a2126b542c3efdd4
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
