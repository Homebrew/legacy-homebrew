require "language/go"

class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/google/cayley"
  url "https://github.com/google/cayley/archive/v0.4.1.tar.gz"
  sha256 "d61f969128bcff1bce1e14e0afa68b9f25e4f3ab8e5f77930a384426f3b3bbce"
  head "https://github.com/google/cayley.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f58e92c03d9ec3bf16911ac5ffc9cd65ce83982f18e8836aafce4a0f9af22b84" => :el_capitan
    sha256 "3364dd8ec9ec244c7c0558e0bbab0e93790d24f00e73263cda9f36a38b729436" => :yosemite
    sha256 "7a02a7326bb2b6f4ba85995553d03322b71c42b24873129a7aa4b375d2bd1c55" => :mavericks
  end

  depends_on "bazaar" => :build
  depends_on :hg => :build
  depends_on "go" => :build

  option "without-samples", "Disable installing sample data"

  # Go dependencies
  go_resource "github.com/badgerodon/peg" do
    url "https://github.com/badgerodon/peg.git", :revision => "9e5f7f4d07ca576562618c23e8abadda278b684f"
  end

  go_resource "github.com/barakmich/glog" do
    url "https://github.com/barakmich/glog.git", :revision => "fafcb6128a8a2e6360ff034091434d547397d54a"
  end

  go_resource "github.com/cznic/mathutil" do
    url "https://github.com/cznic/mathutil.git", :revision => "f9551431b78e71ee24939a1e9d8f49f43898b5cd"
  end

  go_resource "github.com/julienschmidt/httprouter" do
    url "https://github.com/julienschmidt/httprouter.git", :revision => "b59a38004596b696aca7aa2adccfa68760864d86"
  end

  go_resource "github.com/petar/GoLLRB/llrb" do
    url "https://github.com/petar/GoLLRB.git", :revision => "53be0d36a84c2a886ca057d34b6aa4468df9ccb4"
  end

  go_resource "github.com/peterh/liner" do
    url "https://github.com/peterh/liner.git", :revision => "1bb0d1c1a25ed393d8feb09bab039b2b1b1fbced"
  end

  go_resource "github.com/robertkrimen/otto" do
    url "https://github.com/robertkrimen/otto.git", :revision => "d1b4d8ef0e0e4b088c8328c95ca63ab9ebd8fc9d"
  end

  go_resource "github.com/syndtr/gosnappy" do
    url "https://github.com/syndtr/gosnappy.git", :revision => "156a073208e131d7d2e212cb749feae7c339e846"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git", :revision => "8e87604bec3c645a4eeaee97dfec9f25811ff20d"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git", :revision => "17bb7999de6cfb791d4f8986cc00b3309b370cdb"
  end

  go_resource "github.com/syndtr/goleveldb" do
    url "https://github.com/syndtr/goleveldb.git", :revision => "4875955338b0a434238a31165cb87255ab6e9e4a"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git", :revision => "3b449559cf34cbcc74460b59041a4399d3226e5a"
  end

  # It looks for both unstable and stable mgo in GOPATH during compile.
  go_resource "gopkg.in/mgo.v2" do
    url "https://github.com/go-mgo/mgo.git", :revision => "c6a7dce14133ccac2dcac3793f1d6e2ef048503a"
  end

  go_resource "gopkg.in/mgo.v2-unstable" do
    url "https://github.com/go-mgo/mgo.git", :revision => "7a4943433e00707e38099a2b2e904d96681d14bc"
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid/", :revision => "35bc42037350", :using => :hg
  end

  def install
    # Prepare for Go build
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    # To avoid re-downloading Cayley, symlink its source from the tarball so that Go can find it
    mkdir_p "src/github.com/google/"
    ln_s buildpath, "src/github.com/google/cayley"

    # Build
    system "go", "build", "-o", "cayley", "github.com/google/cayley"

    # Create sample configuration that uses the Homebrew-based directories
    inreplace "cayley.cfg.example", "/tmp/cayley_test", "#{var}/cayley"

    # Install binary and configuration
    bin.install "cayley"
    etc.install "cayley.cfg.example" => "cayley.conf"

    # Copy over the static web assets
    (share/"cayley/assets").install "docs", "static", "templates"

    if build.with? "samples"
      system "gzip", "-d", "data/30kmoviedata.nq.gz"

      # Copy over sample data
      (share/"cayley/samples").install "data/testdata.nq", "data/30kmoviedata.nq"
    end
  end

  def post_install
    unless File.exist? "#{var}/cayley"
      # Create data directory
      (var/"cayley").mkpath

      # Initialize the Cayley database
      system "#{bin}/cayley", "init", "--config=#{etc}/cayley.conf"
    end
  end

  plist_options :manual => "cayley http --assets=#{HOMEBREW_PREFIX}/share/cayley/assets --config=#{HOMEBREW_PREFIX}/etc/cayley.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cayley</string>
          <string>http</string>
          <string>--assets=#{share}/cayley/assets</string>
          <string>--config=#{etc}/cayley.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/cayley</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/cayley.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/cayley.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    result = pipe_output("#{bin}/cayley version")
    assert_match result, "Cayley snapshot\n"
  end
end
