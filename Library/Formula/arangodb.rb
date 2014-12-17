require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url 'https://www.arangodb.com/repositories/Source/ArangoDB-2.3.3.tar.gz'
  sha1 '2429ecdb8499d1524da15bf86749fd58a115a70c'

  head "https://github.com/triAGENS/ArangoDB.git", :branch => 'unstable'

  bottle do
    sha1 "400031de8f90c2bac57898fe36d6343f9a51aaa2" => :yosemite
    sha1 "756ce1938ef5ee5f7f3333ef8d55c23a94b2ae52" => :mavericks
    sha1 "79458b5343ba215854090749c6d8f1f3f39e75a6" => :mountain_lion
  end

  depends_on 'go' => :build
  depends_on 'openssl'

  needs :cxx11

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
    ]

    args << "--program-suffix=unstable" if build.head?

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
