require 'formula'

class Arangodb < Formula
  homepage 'https://www.arangodb.com/'
  url 'https://www.arangodb.com/repositories/Source/ArangoDB-2.5.2.tar.gz'
  sha1 '5dc2f7a2c6ec83a55c01da4968f212abb11aa136'

  head "https://github.com/arangodb/arangodb.git", :branch => 'unstable'

  bottle do
    sha256 "87fa40c937c6ed3f5202752970405f6cfe7401b258571ae179d811261badcd59" => :yosemite
    sha256 "768792c539eec0b07692019bd10b0afc6882d0e135c23e45fc67e604af3ea5a6" => :mavericks
    sha256 "4897e4f7afc96b1f4dd5f8787ab5d925651c835cea80ad3377ee3054e2b56350" => :mountain_lion
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
