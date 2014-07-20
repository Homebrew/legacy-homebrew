require "formula"

class Cayley < Formula
  homepage "https://github.com/google/cayley"
  url "https://github.com/google/cayley/archive/v0.3.0.tar.gz"
  sha1 "b69b1da6854cf174854034061ab0919fcf0c18b8"
  head "https://github.com/google/cayley.git"

  bottle do
    revision 1
    sha1 "10d398eaaf1d7016f20cb179e6fc5aaddc78d5b5" => :mavericks
    sha1 "7929ce3816e78fbab798c2fb95aab0352b6a127e" => :mountain_lion
    sha1 "5bd96b3602df9fd6dac235dfb6545a19e110ed5f" => :lion
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
    system "go", "get", "labix.org/v2/mgo"
    system "go", "get", "labix.org/v2/mgo/bson"

    # HEAD does not require the extra work to get 0.3.0 to build properly so avoid it
    unless build.head?
      # Install Go dependencies
      system "go", "get", "github.com/stretchrcom/testify/mock"

      # Fix issue where 0.3.0 builds againsts an old version of syndtr/goleveldb
      inreplace "graph/leveldb/leveldb_triplestore.go", "GetApproximateSizes", "SizeOf"
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
      system "gzip", "-d", "30kmoviedata.nt.gz"

      # Copy over sample data
      (share/'cayley/samples').install "testdata.nt", "30kmoviedata.nt"
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
    require 'open3'

    touch "test.nt"

    Open3.popen3("#{bin}/cayley", "repl", "--dbpath=#{testpath}/test.nt") do |stdin, stdout, _|
      stdin.write "graph.Vertex().All()"
      stdin.close

      result = stdout.read.strip

      assert !result.include?("Error:")
      assert result.include?("Elapsed time:")
    end
  end
end
