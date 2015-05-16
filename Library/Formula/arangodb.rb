require 'formula'

class Arangodb < Formula
  homepage 'https://www.arangodb.com/'
  url 'https://www.arangodb.com/repositories/Source/ArangoDB-2.5.3.tar.gz'
  sha1 '92f9165dab6d23213691104621259a418dc37caf'

  head "https://github.com/arangodb/arangodb.git", :branch => 'unstable'

  bottle do
    sha256 "cc3183baaa1593ebfe547d9d65d1bc160c64e1af47cc81649cb0d680180033a4" => :yosemite
    sha256 "ed86246343586d0a1d280f7b85e6120c320e38f82d2c0410bc5643d156512388" => :mavericks
    sha256 "e59bca53798ff6f9d49a5919cd96cf58ae28624e3c7c8561db19f514f771d547" => :mountain_lion
  end

  depends_on 'go' => :build
  depends_on 'openssl'

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
