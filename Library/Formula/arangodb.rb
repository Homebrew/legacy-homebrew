require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url 'https://www.arangodb.org/repositories/Source/ArangoDB-2.2.0.tar.gz'
  sha1 '6c1886c606f73f9d3dfbc3d58293cc4f47a07491'

  head "https://github.com/triAGENS/ArangoDB.git", :branch => 'unstable'

  bottle do
    sha1 "2696710c1befec12be71b55ca5f70927fd4716b7" => :mavericks
    sha1 "52cf255b9115104cb01a133290621da7a161595e" => :mountain_lion
    sha1 "9dfaba919243e834b5f526de1b061c5e5a241252" => :lion
  end

  depends_on 'go' => :build

  if MacOS.version < :mavericks
    depends_on 'gcc' => :build

    fails_with :clang do
      cause "ArangoDB needs 'unorded_maps' which are not available in this version of clang"
    end

    fails_with :llvm do
      cause "ArangoDB needs 'unorded_maps' which are not available in this version of llvm"
    end
  else
    needs :cxx11
  end

  def suffix
    if build.stable?
      return ""
    else
      return "-" + (build.devel? ? version : "unstable")
    end
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --enable-all-in-one-icu
      --enable-all-in-one-libev
      --enable-all-in-one-v8
      --enable-mruby
      --datadir=#{share}
      --localstatedir=#{var}
      --program-suffix=#{suffix}
    ]

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
