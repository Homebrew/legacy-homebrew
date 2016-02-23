class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.8.2.tar.gz"
  sha256 "70a546e1e0f5a56d74af0cedbfe6b2c53b04ca09ca1982f9713231112490c1de"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    revision 1
    sha256 "6ee86500a8b7ee5dc7f9a3c91161294f6e2fe143f5b283ea86495614a7c1f5a3" => :el_capitan
    sha256 "0210557b60bec2cfa7822396454e2f0fba5b0f2c48283b658bb54297df0f218c" => :yosemite
    sha256 "9486710a4f8b38ffa5cb4ed20e2b6d113245990772dee6632214dc93fcc12fd8" => :mavericks
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
