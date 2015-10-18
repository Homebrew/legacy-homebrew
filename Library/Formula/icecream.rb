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
    sha256 "10f85e172c5c435d81e7c05595c5ae9a9ffa83490dded7eefa95f9ad401fb31b"

    # fixes --without-man
    patch do
      url "https://github.com/icecc/icecream/commit/641b039ecaa126fbb3bdfa716ce3060f624bb68e.diff"
      sha256 "f92bf6b619f6322a030e17b3561f0fb33a87cf2b0b60a6ca55777a4237ad886a"
    end

    # these fix docbook2X detection
    patch do
      url "https://github.com/icecc/icecream/commit/df212c10336b6369ab244d9c888263774c9087dc.diff"
      sha256 "0df0ea51f9435faaa51924037979c714663f3e8bfd87122850483a72b5743344"
    end

    patch do
      url "https://github.com/icecc/icecream/commit/a40bae096bd51f328d6ff299077c5530729b0580.diff"
      sha256 "968ec139f87deb410a75d9287ba1a6fb289a5c86648775eb0aebe998e06c1fcb"
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
    sha256 "95bdb66228cc8f5d97a829f1ee4e3f2d32caf064e9614919e8af0f708a13c654"

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
