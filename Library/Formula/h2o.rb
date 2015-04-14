class H2o < Formula
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v1.2.0.tar.gz"
  sha256 "09aacd84ea0a53eaffdc8e0c2a2cf1108bea5db81d5859a136221fd67f07833f"
  head "https://github.com/h2o/h2o.git"

  bottle do
    sha256 "f696a00cd5b37e0e636c7eaebdf302ce36e96ad85a750abea0e95edebfaec03b" => :yosemite
    sha256 "9472f7c2b13ccd9f8a4a33855692cbddc410a84dee3ee72790ad9801f29b34b6" => :mavericks
    sha256 "c52f71d13c56d0cf77e130e400359fb1214157ce76920516ccd04deab1083779" => :mountain_lion
  end

  option "with-libuv", "Build the H2O library in addition to the executable."

  depends_on "cmake" => :build
  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "libuv" => :optional
  depends_on "wslay" => :optional

  def install
    args = std_cmake_args
    args << "."
    args << "-DWITH_BUNDLED_SSL=OFF"

    system "cmake", *args

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
