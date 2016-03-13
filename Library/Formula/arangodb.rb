class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.8.5.tar.gz"
  sha256 "d09a046120371de42842fe6506d4ab37032b8e228afafba83f6f0fad2b4403ee"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "dab863de242a3bcfb833e2335135748657df740e37bac845a057e886e07635e2" => :el_capitan
    sha256 "6b048787352f99f64720a0a6de04519f9e1488d3a20be37f1e3b0c6e1cd77fb2" => :yosemite
    sha256 "acd9a070e1dd54e345160ac72378f276ad3b9c5819f72d2ff759299efa908911" => :mavericks
  end

  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    # clang on 10.8 will still try to build against libstdc++,
    # which fails because it doesn't have the C++0x features
    # arangodb requires.
    ENV.libcxx

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --datadir=#{share}
      --localstatedir=#{var}
    ]

    args << "--program-suffix=-unstable" if build.head?

    if ENV.compiler != :clang
      ENV.append "LDFLAGS", "-static-libgcc -static-libstdc++"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"arangodb").mkpath
    (var/"log/arangodb").mkpath

    system "#{sbin}/arangod" + (build.head? ? "-unstable" : ""), "--upgrade", "--log.file", "-"
  end

  def caveats; <<-EOS.undent
    Please note that clang and/or its standard library 7.0.0 has a severe
    performance issue. Please consider using '--cc=gcc-5' when installing
    if you are running on such a system.
    EOS
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
