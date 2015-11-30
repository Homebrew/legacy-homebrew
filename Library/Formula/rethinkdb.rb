class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://download.rethinkdb.com/dist/rethinkdb-2.2.1.tgz"
  sha256 "6611b4e62020a68c23e0a1f0a517b97677e0358c261a3e188d14b02b014a2c9e"

  bottle do
    cellar :any
    sha256 "6258c8d65ecadf89ed7ce11259ddd3e700ee7ad9bb51dfbf742d7bd686119320" => :el_capitan
    sha256 "9c9e77fe00e25ba430c8550a418ecebd9e2cb366e135b42ec5218c206ece59ee" => :yosemite
    sha256 "5ae5ebd460bf8a7bdd2d4a77d00f6a20721133c48985651162d573fc20a29a99" => :mavericks
  end

  depends_on :macos => :lion
  depends_on "boost" => :build
  depends_on "openssl"

  fails_with :gcc do
    build 5666 # GCC 4.2.1
    cause "RethinkDB uses C++0x"
  end

  def install
    args = ["--prefix=#{prefix}"]

    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args += ["--fetch", "protobuf"]

    system "./configure", *args
    system "make"
    system "make", "install-osx"

    (var/"log/rethinkdb").mkpath

    (buildpath+"rethinkdb.conf").write rethinkdb_conf
    etc.install "rethinkdb.conf"
  end

  def rethinkdb_conf; <<-EOS.undent
    directory=#{var}/rethinkdb

    ### Network options

    ## Address of local interfaces to listen on when accepting connections
    ## May be 'all' or an IP address, loopback addresses are enabled by default
    ## Default: all local addresses
    bind=127.0.0.1

    ## Address that other rethinkdb instances will use to connect to this server.
    ## It can be specified multiple times
    # canonical-address=

    ## The port for rethinkdb protocol for client drivers
    ## Default: 28015 + port-offset
    # driver-port=28015

    ## The port for receiving connections from other nodes
    ## Default: 29015 + port-offset
    # cluster-port=29015

    ## The host:port of a node that rethinkdb will connect to
    ## This option can be specified multiple times.
    ## Default: none
    # join=example.com:29015

    ## All ports used locally will have this value added
    ## Default: 0
    # port-offset=0

    ## r.http(...) queries will use the given server as a web proxy
    ## Default: no proxy
    # reql-http-proxy=socks5://example.com:1080

    ### Web options

    ## Port for the http admin console
    ## Default: 8080 + port-offset
    # http-port=8080

    ## Disable web administration console
    # no-http-admin

    ### CPU options

    ## The number of cores to use
    ## Default: total number of cores of the CPU
    # cores=2

    ### Memory options

    ## Size of the cache in MB
    ## Default: Half of the available RAM on startup
    # cache-size=1024

    ### Disk

    ## How many simultaneous I/O operations can happen at the same time
    # io-threads=64

    ## Enable direct I/O
    # direct-io

    ### Meta

    ## The name for this server (as will appear in the metadata).
    ## If not specified, it will be randomly chosen from a short list of names.
    # server-name=server1
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
          <string>#{opt_bin}/rethinkdb</string>
          <string>--config-file</string>
          <string>#{etc}/rethinkdb.conf</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end
