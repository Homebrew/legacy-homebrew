class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"

  option "with-docbook2X", "Build with man page"
  option "without-clang-wrappers", "Don't use symlink wrappers for clang/clang++"
  option "with-clang-rewrite-includes", "Use by default Clang's -frewrite-includes option"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "docbook2X" => [:optional, :build]

  stable do
    url "https://github.com/icecc/icecream/archive/1.0.1.tar.gz"
    sha1 "2c3e43d34e4cbe8da5fa49e0518fd4db4c665f81"

    # fixes --without-man
    patch do
      url "https://github.com/icecc/icecream/commit/641b039ecaa126fbb3bdfa716ce3060f624bb68e.diff"
      sha1 "8ef0123a15380602b86dd9b0075b63848c4df7ff"
    end

    # these fix docbook2X detection
    patch do
      url "https://github.com/icecc/icecream/commit/df212c10336b6369ab244d9c888263774c9087dc.diff"
      sha1 "f4a2bd77714fa189e4da3df6ab4837abc517f9cb"
    end

    patch do
      url "https://github.com/icecc/icecream/commit/a40bae096bd51f328d6ff299077c5530729b0580.diff"
      sha1 "c15c3fb20cd73662675284556bf635c24a4a82bf"
    end
  end

  bottle do
    sha1 "df2ce444f943ca2e5f9850f934e1098c043f6888" => :yosemite
    sha1 "cfc146ad19cec4a60a10e8e68399f413b0f41bd7" => :mavericks
    sha1 "f44f687d335131f79cbb70abe69235f880de48e8" => :mountain_lion
  end

  devel do
    url "https://github.com/icecc/icecream/archive/1.1rc1.tar.gz"
    version "1.1rc1"
    sha1 "ccde08f67297122710270b440492a528df042f52"

    depends_on "lzo"
  end

  def install
    ENV.libstdcxx if ENV.compiler == :clang && build.stable?

    args = "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    args << "--without-man" if build.without? "docbook2X"
    args << "--enable-clang-wrappers" if build.with? "clang-wrappers"
    args << "--enable-clang-write-includes" if build.with? "clang-rewrite-includes"
    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"
    (prefix+"org.opensuse.icecc.plist").write iceccd_plist
    (prefix+"org.opensuse.icecc-scheduler.plist").write scheduler_plist
  end

  def caveats; <<-EOS.undent
    To override the toolset with icecc, add to your path:
      #{opt_libexec}/bin/icecc

    To have launchd start the icecc daemo at login:
      cp #{opt_prefix}/org.opensuse.icecc.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.opensuse.icecc.plist
    EOS
  end

  def iceccd_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Daemon</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/iceccd</string>
        <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  def scheduler_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Scheduler</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/icecc-scheduler</string>
        <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<-EOS.undent
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", `./hello-cc`

    if build.with? "clang-wrappers"
      (testpath/"hello-clang.c").write <<-EOS.undent
        #include <stdio.h>
        int main()
        {
          puts("Hello, world!");
          return 0;
        }
      EOS
      system opt_libexec/"icecc/bin/clang", "-o", "hello-clang", "hello-clang.c"
      assert_equal "Hello, world!\n", `./hello-clang`

      (testpath/"hello-cclang.cc").write <<-EOS.undent
        #include <iostream>
        int main()
        {
          std::cout << "Hello, world!" << std::endl;
          return 0;
        }
      EOS
      system opt_libexec/"icecc/bin/clang++", "-o", "hello-cclang", "hello-cclang.cc"
      assert_equal "Hello, world!\n", `./hello-cclang`
    end
  end
end
