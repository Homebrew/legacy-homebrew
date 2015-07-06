class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.6.2.tar.gz"
  sha256 "673465c868f34e80ef1d6a6b1d949173dbb35a9913664aa17bb6c2b7175f29fe"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "3e30a733cc0e0b74ec6703df4c4b46ca7c1fe038b1a0a87ce9fbfbda956bb894" => :yosemite
    sha256 "661e446f1be82d62c735359afa557ad7c38f5febee233488fd8eb9d54390955e" => :mavericks
    sha256 "56cd3864d579bfb22757a1999e4eb5687ef3bb36e7307612d5678bfb622ab5c6" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  def install
    # clang on 10.8 will still try to build against libstdc++,
    # which fails because it doesn't have the C++0x features
    # arangodb requires.
    ENV.libcxx

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --enable-mruby
      --datadir=#{share}
      --localstatedir=#{var}
    ]

    args << "--program-suffix=-unstable" if build.head?

    system "./configure", *args
    system "make", "install"

    (var/"arangodb").mkpath
    (var/"log/arangodb").mkpath
  end

  def post_install
    system "#{sbin}/arangod" + (build.head? ? "-unstable" : ""), "--upgrade", "--log.file", "-"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod" + (build.head? ? "-unstable" : "") + " --log.file -"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
