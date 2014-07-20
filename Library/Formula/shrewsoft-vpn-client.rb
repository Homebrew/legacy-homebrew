require "formula"

class ShrewsoftVpnClient < Formula
  homepage "https://www.shrew.net"
  url "https://www.shrew.net/download/ike/ike-2.2.1-release.tbz2"
  sha1 "a52a49248fa663dfbd9e208eaa3e706a17bb9c8c"
  head "svn://svn.shrew.net/ike/head"

  option "without-gui", "Don't build Client GUI"
  option "without-natt", "Disable Nat Traversal Support"
  option "without-ldap", "Disable LDAP Authentication Support"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "tuntap"
  depends_on "qt" if build.with? "gui"

  def install
    # upstream request to support specifying Application/Framework folders:
    # https://lists.shrew.net/pipermail/vpn-devel/2014-January/000636.html

    # there is no suport for an alternate Frameworks folder, must change hard-coded paths
    Dir.glob(%w[source/*/CMakeLists.txt package/macosx/vpn-client-install.packproj]) do |path|
      next unless File.read(path).include? "/Library/Frameworks"
      inreplace path, "/Library/Frameworks", frameworks
    end
    frameworks.mkpath

    # there is no suport for an alternate Applications folder, must change hard-coded paths
    if build.with? "gui"
      %w{
        package/macosx/vpn-client-install.packproj
        source/qikea/CMakeLists.txt
        source/qikea/root.cpp
        source/qikec/CMakeLists.txt
      }.each { |path| inreplace path, "/Applications", prefix }
    end

    cmake_args = std_cmake_args + [
      "-DETCDIR=#{etc}",
      "-DBINDIR=#{bin}",
      "-DSBINDIR=#{sbin}",
      "-DLIBDIR=#{lib}",
      "-DMANDIR=#{man}"
    ]
    cmake_args << "-DQTGUI=YES" if build.with? "gui"
    cmake_args << "-DNATT=YES" if build.with? "natt"
    cmake_args << "-DLDAP=YES" if build.with? "ldap"

    system "cmake", *cmake_args

    # change relative framework paths to absolute ones (otherwise /Library/Frameworks is assumed)
    Dir.glob("source/*/cmake_install.cmake") do |path|
      inreplace path, /"(ShrewSoft.+?\.framework)/, "\"#{frameworks}/\\1"
    end

    system "make", "install"

    etc.install etc/"iked.conf.sample" => "iked.conf"
  end

  plist_options :manual => "sudo #{HOMEBREW_PREFIX}/sbin/iked", :startup => true

  def plist; <<-EOF.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>net.shrew.iked</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/sbin/iked</string>
          <string>-F</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>UserName</key>
        <string>root</string>
        <key>Sockets</key>
        <dict>
          <key>Listeners</key>
          <dict>
            <key>SockFamily</key>
            <string>Unix</string>
            <key>SockPathMode</key>
            <integer>755</integer>
            <key>SockPathName</key>
            <string>/var/run/ikedi</string>
          </dict>
        </dict>
      </dict>
    </plist>
    EOF
  end

end
