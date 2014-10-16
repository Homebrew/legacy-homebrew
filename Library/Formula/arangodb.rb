require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url 'https://www.arangodb.org/repositories/Source/ArangoDB-2.2.5.tar.gz'
  sha1 'e0522685659d49ab2718f4f6505a38ddf740df63'

  head "https://github.com/triAGENS/ArangoDB.git", :branch => 'unstable'

  bottle do
    sha1 "ec38019541bb1752a5998963986370d9aa78cd61" => :mavericks
    sha1 "968d7b64d48b76547621e211b65ad9b15a7397f4" => :mountain_lion
    sha1 "2d94797597df6f3d831546652e21ab8a491f99c0" => :lion
  end

  depends_on 'go' => :build

  needs :cxx11

  def suffix
    if build.stable?
      return ""
    else
      return "-" + (build.devel? ? version : "unstable")
    end
  end

  def install
    # clang on 10.8 will still try to build against libstdc++,
    # which fails because it doesn't have the C++0x features
    # arangodb requires.
    ENV.libcxx

    # Bundled V8 tries to build with a 10.5 deployment target,
    # which causes clang to error out b/c a 10.5 deployment target
    # and -stdlib=libc++ are not valid together.
    inreplace "3rdParty/V8/build/standalone.gypi",
      "'mac_deployment_target%': '10.5',",
      "'mac_deployment_target%': '#{MacOS.version}',"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --enable-all-in-one-icu
      --enable-all-in-one-libev
      --enable-all-in-one-v8
      --enable-mruby
      --datadir=#{share}
      --localstatedir=#{var}
      --program-suffix=#{suffix}
    ]

    system "./configure", *args
    system "make install"

    (var/'arangodb').mkpath
    (var/'log/arangodb').mkpath
  end

  def post_install
    system "#{sbin}/arangod", "--upgrade", "--log.file", "-"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod --log.file -"

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
