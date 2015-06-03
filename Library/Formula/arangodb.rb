require 'formula'

class Arangodb < Formula
  homepage 'https://www.arangodb.com/'
  url 'https://www.arangodb.com/repositories/Source/ArangoDB-2.5.5.tar.gz'
  sha1 'e8ca48870222f68189881eb09b431cce02bfb7d8'

  head "https://github.com/arangodb/arangodb.git", :branch => 'unstable'

  bottle do
    sha256 "e1b8492d5bb327eebd5d046c35889e0ec2d7e01e56965585cf91fa1d065feaee" => :yosemite
    sha256 "e94bf46aecaf70ea4a114a2974c6d5df6cb5a1fec9a585a56829ec69fc9fb58b" => :mavericks
    sha256 "de8f83b412fd3edbf5dc3449920ee309bfc171b950cff1b9a9692564a4082e43" => :mountain_lion
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
