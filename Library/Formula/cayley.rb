require "formula"

class Cayley < Formula
  homepage "https://github.com/google/cayley"
  url "https://github.com/google/cayley/archive/v0.3.1.tar.gz"
  sha1 "6b0e8876e5dc642e3cbecf2ea9eaadb47ea07198"
  head "https://github.com/google/cayley.git"

  bottle do
    sha1 "a84f30dd36528429562a132375fcf778bde18329" => :mavericks
    sha1 "1056e0a68317c7890941848a12740d90dcc04366" => :mountain_lion
    sha1 "74d9a3922d9f14c3c85b6b3d5f307be358b91ff5" => :lion
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
    system "go", "get", "github.com/julienschmidt/httprouter"
    system "go", "get", "github.com/petar/GoLLRB/llrb"
    system "go", "get", "github.com/robertkrimen/otto"
    system "go", "get", "github.com/russross/blackfriday"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/cache"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/iterator"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/opt"
    system "go", "get", "github.com/syndtr/goleveldb/leveldb/util"
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
    testdata = "#{HOMEBREW_PREFIX}/share/cayley/samples/testdata.nq"
    result = pipe_output("#{bin}/cayley repl --db memstore --dbpath=#{testdata}", "graph.Vertex().All()")
    assert !result.include?("Error:")
    assert result.include?("Elapsed time:")
  end
end
