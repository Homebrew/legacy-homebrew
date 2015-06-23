require 'formula'

class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage 'https://www.arangodb.com/'
  url 'https://www.arangodb.com/repositories/Source/ArangoDB-2.6.0.tar.gz'
  sha256 'fec63994692cfb851369e3d074ae0a0e240ef2b362990deca6babc5fd7929b0d'

  head "https://github.com/arangodb/arangodb.git", :branch => 'unstable'

  bottle do
    sha256 "022442171a83fc3605783249ca1d6f8458818e4327ff36ea4f3b62b80ee119c8" => :yosemite
    sha256 "e2e79447c2616b005f099fd7b4d7b8725fcad8e4d7f567ec7d3d8e9c1b131cca" => :mavericks
    sha256 "ee824f0b85f11ca6e5e887d019dc51ff4291255d6b50e661e18e9e7876df8663" => :mountain_lion
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

    args << "--program-suffix=-unstable" if build.head?

    system "./configure", *args
    system "make install"

    (var/'arangodb').mkpath
    (var/'log/arangodb').mkpath
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
