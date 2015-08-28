class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.6.7.tar.gz"
  sha256 "b2f3953a90145074f8a20e6ff63e41d40798c55802a85091feafb96e0bc81c53"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "1b89d10e0c61cf48c5b7ea28b802e8bb3eee61922684985e97661ca8ea5fabd2" => :yosemite
    sha256 "3405b4cbc2dffa719f8d9be7e307ec21eba5d3c46579b5a6c638bf4b9471a10c" => :mavericks
    sha256 "53da9ccb8d08d2da38c5cbcdbcfc99386bde963e0b50d2016dd340510d070339" => :mountain_lion
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
