require "formula"

class Mongodb < Formula
  homepage "http://www.mongodb.org/"
  url "http://downloads.mongodb.org/src/mongodb-src-r2.6.4.tar.gz"
  sha1 "16dda6d8b1156194fc09b5ad72e58612d06abada"
  revision 1

  bottle do
    revision 1
    sha1 "f0d3195b48bbfa726f7c263a841610f5e96d3527" => :mavericks
    sha1 "d4cb743f2d8bd7c72846f361199e5e6021724d9f" => :mountain_lion
    sha1 "d03344c6d6bea73d8480af83b32f0337d35df5d9" => :lion
  end

  devel do
    url "http://downloads.mongodb.org/src/mongodb-src-r2.7.6.tar.gz"
    sha1 "862e3483a91f839352d2a5f2e0ad3aa7baa7314d"
  end

  head "https://github.com/mongodb/mongo.git"

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  depends_on "boost" => :optional

  depends_on :macos => :snow_leopard
  depends_on "scons" => :build
  depends_on "openssl" => :optional

  # Yosemite build fix, until solved upstream
  # https://jira.mongodb.org/browse/SERVER-14204
  patch :DATA if MacOS.version == "10.10"

  def install
    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --osx-version-min=#{MacOS.version}
    ]

    # --full installs development headers and client library, not just binaries
    # (only supported pre-2.7)
    args << "--full" if build.stable?
    args << "--use-system-boost" if build.with? "boost"
    args << "--64" if MacOS.prefer_64_bit?

    if build.with? "openssl"
      args << "--ssl" << "--extrapath=#{Formula["openssl"].opt_prefix}"
    end

    scons "install", *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+"mongodb").mkpath
    (var+"log/mongodb").mkpath
  end

  def mongodb_conf; <<-EOS.undent
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
    EOS
  end

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end

__END__
--- mongodb-2.6.4/SConstruct.orig	2014-09-23 15:09:49.000000000 +0200
+++ mongodb-2.6.4/SConstruct	2014-09-23 15:10:13.000000000 +0200
@@ -307,7 +307,7 @@
            0, False)

 if darwin:
-    osx_version_choices = ['10.6', '10.7', '10.8', '10.9']
+    osx_version_choices = ['10.6', '10.7', '10.8', '10.9', '10.10']
     add_option("osx-version-min", "minimum OS X version to support", 1, True,
                type = 'choice', default = osx_version_choices[0], choices = osx_version_choices)

--- mongodb-2.6.4/src/third_party/s2/util/endian/endian.h.orig	2014-09-28 01:08:51.000000000 +0200
+++ mongodb-2.6.4/src/third_party/s2/util/endian/endian.h	2014-09-28 01:09:06.000000000 +0200
@@ -177,15 +177,4 @@
   }
 };

-
-// This one is safe to take as it's an extension
-#define htonll(x) ghtonll(x)
-
-// ntoh* and hton* are the same thing for any size and bytesex,
-// since the function is an involution, i.e., its own inverse.
-#define gntohl(x) ghtonl(x)
-#define gntohs(x) ghtons(x)
-#define gntohll(x) ghtonll(x)
-#define ntohll(x) htonll(x)
-
 #endif  // UTIL_ENDIAN_ENDIAN_H_
