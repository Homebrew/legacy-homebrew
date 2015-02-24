class H2o < Formula
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v1.0.1.tar.gz"
  sha1 "1c66c59123a3e23172b610380af5e78d5e95a78a"
  head "https://github.com/h2o/h2o.git"

  bottle do
    sha1 "3f62c3b78c9351e9c581c1242e1d999a0ba50555" => :yosemite
    sha1 "cc13b80fe91ae1ee827ca745e7f3692c76c941b7" => :mavericks
    sha1 "f58b952c6fc29d9db30f506e3bc3edef6422725c" => :mountain_lion
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
