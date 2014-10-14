require 'formula'

class Gearman < Formula
  homepage 'http://gearman.org/'
  url "https://launchpad.net/gearmand/1.0/1.0.6/+download/gearmand-1.0.6.tar.gz"
  sha1 "872d5e13c20a29a20e45df3afa8f3981dc52d363"

  bottle do
    sha1 "b1d76be880294ad7900c18628674c9853b7d6a14" => :mavericks
    sha1 "43aa44d53ca68b67978beeb94613c8418e4d0eaf" => :mountain_lion
    sha1 "d09770f6262eed1c7ababa6f06e9659e12694e9a" => :lion
  end

  devel do
    url "https://launchpad.net/gearmand/1.2/1.1.12/+download/gearmand-1.1.12.tar.gz"
    sha1 "85b5271ea3ac919d96fff9500993b73c9dc80c6c"

    depends_on "cyassl" => :optional
    depends_on "openssl" => :optional

    patch :p0 do
      # https://bugs.launchpad.net/gearmand/+bug/1318151
      url "https://launchpadlibrarian.net/179708850/gearman-1.1.12-client.cc.patch"
      sha1 "1217ca4da09fd0a0e6a7333e89545a3707c550e4"
    end
  end

  option 'with-mysql', 'Compile with MySQL persistent queue enabled'
  option 'with-postgresql', 'Compile with Postgresql persistent queue enabled'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'libevent'
  depends_on :mysql => :optional
  depends_on :postgresql => :optional
  depends_on "libpqxx" if build.with? "postgresql"
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional

  def install

    if build.stable? && MacOS.version >= :mavericks
      # https://bugs.launchpad.net/gearmand/+bug/1236815
      inreplace "configure", "<tr1/", "<"
      inreplace "libgearman-1.0/gearman.h", "<tr1/", "<"
    end

    if build.devel?
      # https://bugs.launchpad.net/gearmand/+bug/1236815
      inreplace "libgearman-1.0/gearman.h", "#  include <cinttypes>", "#  include \"gear_config.h\""

      # https://bugs.launchpad.net/gearmand/+bug/1368926
      Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
        next unless /std::unique_ptr/ === File.read(test_file)
        inreplace test_file, "std::unique_ptr", "std::auto_ptr"
      end
    end

    args = [
      "--prefix=#{prefix}",
      "--with-boost=#{Formula['boost'].prefix}",
      "--with-sqlite3"
    ]

    if build.devel?
      if build.with? "cyassl"
        args << "--enable-ssl" << "--enable-cyassl"
      elsif build.with? "openssl"
        args << "--enable-ssl" << "--with-openssl=#{Formula['openssl'].prefix}" << "--disable-cyassl"
      else
        args << "--disable-ssl" << "--disable-cyassl"
      end
    end

    if build.with? "postgresql"
      args << "--enable-libpq" << "--with-postgresql=#{Formula['postgresql'].opt_bin}/pg_config"
    else
      args << "--disable-libpq" << "--without-postgresql"
    end

    if build.with? "libmemcached"
      args << "--enable-libmemcached" << "--with-memcached=#{Formula['memcached'].opt_bin}/memcached"
    else
      args << "--disable-libmemcached" << "--without-memcached"
    end

    args << (build.with?("mysql") ? "--with-mysql=#{Formula['mysql'].opt_bin}/mysql_config" : "--without-mysql")
    args << (build.with?("hiredis") ? "--enable-hiredis" : "--disable-hiredis")

    system "./configure", *args
    system "make install"
  end

  plist_options :manual => "gearmand -d"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
