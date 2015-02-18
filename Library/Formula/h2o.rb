class H2o < Formula
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v1.0.0.tar.gz"
  sha1 "9215eb3ec6b7455ce20b3dc3d322c327d0e56dad"
  head "https://github.com/h2o/h2o.git"

  bottle do
    sha1 "d24d3bc8ccc70d1477da59d491f7253a03c80e18" => :yosemite
    sha1 "d6094ddfe20c65fab8c2aec40474e869444b43d0" => :mavericks
    sha1 "fca51e0cc272fc98a57c8caa524835053cdecdde" => :mountain_lion
  end

  option "with-libuv", "Build the H2O library in addition to the executable."

  depends_on "cmake" => :build
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "libuv" => :optional
  depends_on "wslay" => :optional

  def install
    system "cmake", ".", *std_cmake_args

    if build.with? "libuv"
      system "make", "libh2o"
      lib.install "libh2o.a"
    end

    system "make", "install"

    mkdir_p etc/"h2o"
    mkdir_p var/"h2o"
    (var+"h2o").install "examples/doc_root/index.html"
    # Write up a basic example conf for testing.
    (buildpath+"brew/h2o.conf").write conf_example
    (etc+"h2o").install buildpath/"brew/h2o.conf"
  end

  # This is simplified from examples/h2o/h2o.conf upstream.
  def conf_example; <<-EOS.undent
    listen: 8080
    hosts:
      "127.0.0.1.xip.io:8080":
        paths:
          /:
            file.dir: #{var}/h2o/
    EOS
  end

  def caveats; <<-EOS.undent
    A basic example configuration file has been placed in #{etc}/h2o.
    You can find fuller, unmodified examples here:
      https://github.com/h2o/h2o/tree/master/examples/h2o
    EOS
  end

  plist_options :manual => "h2o"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/h2o</string>
            <string>-c</string>
            <string>#{etc}/h2o/h2o.conf</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"h2o", "--version"
  end
end
