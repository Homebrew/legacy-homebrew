require 'formula'

class Arangodb < Formula
  homepage 'https://www.arangodb.com/'
  url 'https://www.arangodb.com/repositories/Source/ArangoDB-2.5.0.tar.gz'
  sha1 '8d9477296e209933203782ea0ce4162810ab9a60'

  head "https://github.com/arangodb/arangodb.git", :branch => 'unstable'

  bottle do
    sha256 "514ff59cddb8292cfe733fb91146c187e6ada014f35172f16c141d3f32d90abf" => :yosemite
    sha256 "96cc16e8c585aa6ddac3e7993cddcdd49caa356467a03208ca11068d79f19fd5" => :mavericks
    sha256 "f2f2cc325cfbbdcf37fd6dd06f2a2cbe9ebdc0187b14ec15f64f467de9a2af2e" => :mountain_lion
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
