class Polipo < Formula
  desc "Web caching proxy"
  homepage "http://www.pps.jussieu.fr/~jch/software/polipo/"
  url "http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz"
  sha256 "a259750793ab79c491d05fcee5a917faf7d9030fb5d15e05b3704e9c9e4ee015"

  head "git://git.wifi.pps.jussieu.fr/polipo"

  bottle do
    sha1 "b8a3690483249552c1ca12c8173767b847f7e296" => :yosemite
    sha1 "40c9e227cc80b2378d0c5c0c397e7638628d694f" => :mavericks
    sha1 "e293417dcc1d1708cdef6cc5476445741ee97bb4" => :mountain_lion
  end

  option "with-large-chunks", "Set chunk size to 16k (more RAM, but more performance)"

  def install
    cache_root = (var + "cache/polipo")
    cache_root.mkpath
    args = %W[PREFIX=#{prefix}
              LOCAL_ROOT=#{share}/polipo/www
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
        <!-- Set `ulimit -n 20480`. The default OS X limit is 256, that's
             not enough for Polipo (displays 'too many files open' errors).
             It seems like you have no reason to lower this limit
             (and unlikely will want to raise it). -->
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>20480</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
