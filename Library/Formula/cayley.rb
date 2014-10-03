require "formula"

class Cayley < Formula
  homepage "https://github.com/google/cayley"
  url "https://github.com/google/cayley/archive/v0.4.0.tar.gz"
  sha1 "100c1e057fb140b35e1ecdd4824541436e6cb741"
  head "https://github.com/google/cayley.git"

  bottle do
    sha1 "fb10fc8d9b76f5d922d19ecb3c8cc0378ffdb4af" => :mavericks
    sha1 "7fa6f1f652c74f5047bcccf260a336ad6f9ff6f0" => :mountain_lion
    sha1 "2b7346b6b6991188de60eb1e35459357bad24e3f" => :lion
  end

  depends_on "bazaar" => :build
  depends_on :hg => :build
  depends_on "go" => :build

  option "without-samples", "Disable installing sample data"

  def install
    # Prepare for Go build
    ENV["GOPATH"] = buildpath

    # To avoid re-downloading Cayley, symlink its source from the tarball so that Go can find it
    mkdir_p "src/github.com/google/"
    ln_s buildpath, "src/github.com/google/cayley"

    # Install Go dependencies
    system "go", "get", "github.com/badgerodon/peg"
    system "go", "get", "github.com/barakmich/glog"
    system "go", "get", "github.com/cznic/mathutil"
    system "go", "get", "github.com/julienschmidt/httprouter"
    system "go", "get", "github.com/petar/GoLLRB/llrb"
    system "go", "get", "github.com/peterh/liner"
    system "go", "get", "github.com/robertkrimen/otto"
    system "go", "get", "github.com/russross/blackfriday"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/cache"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/iterator"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/opt"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/util"
    system "go", "get", "github.com/boltdb/bolt"
    system "go", "get", "gopkg.in/mgo.v2"
    system "go", "get", "gopkg.in/mgo.v2/bson"

    # HEAD does not require the extra work to get 0.3.1 to build properly so avoid it
    unless build.head?
      # Install Go dependencies
      system "go", "get", "github.com/stretchrcom/testify/mock"
    end

    # Build
    system "go", "build", "-o", "cayley"

    # Create sample configuration that uses the Homebrew-based directories
    inreplace "cayley.cfg.example", "/tmp/cayley_test", "#{var}/cayley"

    # Install binary and configuration
    bin.install "cayley"
    etc.install "cayley.cfg.example" => "cayley.conf"

    # Copy over the static web assets
    (share/'cayley/assets').install "docs", "static", "templates"

    if build.with? "samples"
      system "gzip", "-d", "30kmoviedata.nq.gz"

      # Copy over sample data
      (share/'cayley/samples').install "testdata.nq", "30kmoviedata.nq"
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
    assert result.include?("Cayley snapshot")
  end
end
