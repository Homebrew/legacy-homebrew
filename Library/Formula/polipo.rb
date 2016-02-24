class Polipo < Formula
  desc "Web caching proxy"
  homepage "http://www.pps.jussieu.fr/~jch/software/polipo/"
  url "http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz"
  sha256 "a259750793ab79c491d05fcee5a917faf7d9030fb5d15e05b3704e9c9e4ee015"

  head "git://git.wifi.pps.jussieu.fr/polipo"

  bottle do
    sha256 "2034a4d4ddf8542f91e2a977336f4b22ba5d9a5c67adcb5e1cef41559b7e6369" => :el_capitan
    sha256 "13ad85c18936fc72dd1dc8c03f1d821fe3bae10af77ac9145dbdeed5178f5e7f" => :yosemite
    sha256 "22b7c21ac284e81f7c23e00b6de80991dc7376a21208edd2c9d693c8a54a3bf6" => :mavericks
    sha256 "5de1c405d5506806cd915ca4170b51b4e6d23143d7e7ede00824e901ded65e4f" => :mountain_lion
  end

  option "with-large-chunks", "Set chunk size to 16k (more RAM, but more performance)"

  def install
    cache_root = (var + "cache/polipo")
    cache_root.mkpath
    args = %W[PREFIX=#{prefix}
              LOCAL_ROOT=#{pkgshare}/www
              DISK_CACHE_ROOT=#{cache_root}
              MANDIR=#{man}
              INFODIR=#{info}
              PLATFORM_DEFINES=-DHAVE_IPv6]
    args << 'EXTRA_DEFINES="-DCHUNK_SIZE=16384"' if build.with? "large-chunks"

    system "make", "all", *args
    system "make", "install", *args
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/polipo</string>
        </array>
        <!-- Set `ulimit -n 65536`. The default OS X limit is 256, that's
             not enough for Polipo (displays 'too many files open' errors).
             It seems like you have no reason to lower this limit
             (and unlikely will want to raise it). -->
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>65536</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
