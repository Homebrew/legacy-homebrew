class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.2.0.tar.gz"
  sha256 "0601a7f559af6596dff8e18f5c9b17bc66de50d8e05640aa64a3403a841cb228"
  revision 3

  head "http://www.freediameter.net/hg/freeDiameter", :using => :hg

  bottle do
    sha256 "aa6f29018beafbe23e475334ed5be3718ba428e88b0741ef199d66cdaa988d08" => :el_capitan
    sha256 "786f9873dbf0e85e8a54272697404d99fa60f6872fc8fdad54d66e8184c4dc28" => :yosemite
    sha256 "c031628f3bbd387bdea44364fc6e99065216b68f2d2bf61abf516055e69f6620" => :mavericks
  end

  option "with-all-extensions", "Enable all extensions"

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  if build.with? "all-extensions"
    depends_on :postgresql
    depends_on :mysql
    depends_on "swig" => :build
  end

  def install
    args = std_cmake_args + %W[
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]

    args << "-DALL_EXTENSIONS=ON" if build.with? "all-extensions"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make"
      system "make", "install"
    end

    prefix.install "doc", "contrib"

    unless File.exist?(etc/"freeDiameter.conf")
      cp prefix/"doc/freediameter.conf.sample", etc/"freeDiameter.conf"
    end
  end

  def caveats; <<-EOS.undent
    To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

    Sample configuration files can be found in #{prefix}/doc

    For more information about freeDiameter configuration options, read:
      http://www.freediameter.net/trac/wiki/Configuration

    Other potentially useful files can be found in #{prefix}/contrib
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/freeDiameterd</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
