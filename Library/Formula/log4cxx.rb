class Log4cxx < Formula
  desc "Library of C++ classes for flexible logging"
  homepage "https://logging.apache.org/log4cxx/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz"
  sha256 "0de0396220a9566a580166e66b39674cb40efd2176f52ad2c65486c99c920c8c"

  bottle do
    cellar :any
    sha256 "803d857c115430068d91887a218159dd728b87c94c8a819807225817ff9f2ecb" => :yosemite
    sha256 "93b74be0ecb9bdb32ab803fbae0836ad58387a9ff1ba9346334e734596da7b6d" => :mavericks
    sha256 "6b07acbb1e77d8d7edc7e111f57250b9d05c9b9c8aa6f1363f919940695aa1f9" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  option :universal
  option :cxx11

  fails_with :llvm do
    build 2334
    cause "Fails with 'collect2: ld terminated with signal 11 [Segmentation fault]'"
  end

  # Incorporated upstream, remove on next version update
  # https://issues.apache.org/jira/browse/LOGCXX-400 (r1414037)
  # https://issues.apache.org/jira/browse/LOGCXX-404 (r1414037)
  patch :p0 do
    url "https://gist.githubusercontent.com/cawka/b4a79f6b883c46ac1672/raw/be8b4e610a1e21b34aaaf8fb4151362dcfb782ff/LOGCXX-400,LOGCXX-404---r1414037.patch"
    sha256 "822c24f4eebd970aa284672eec2f71c6f8e192a85d78edb15a232c15011a52d4"
  end

  # https://issues.apache.org/jira/browse/LOGCXX-417 (r1556413)
  patch :p0 do
    url "https://gist.githubusercontent.com/cawka/b4a79f6b883c46ac1672/raw/4188731bd771a961a91fcfbe561f3999b555b9c3/LOG4CXX-417---r1556413.patch"
    sha256 "eca194ec349b4925d0ad53d2b67c18b6a1aa7a979e7bd8729cfd1ed1ef4994c7"
  end

  # https://issues.apache.org/jira/browse/LOGCXX-400 (reported)
  patch :p1 do
    url "https://gist.githubusercontent.com/cawka/b4a79f6b883c46ac1672/raw/f33998566cccf91fb84133e101f5a92a14b31aed/LOGCXX-404---domtestcase.cpp.patch"
    sha256 "3eaf321e1df8e8e4a0a507a96646727180e7e721b2c42af22a5d40962d3dbecc"
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.O2 # Using -Os causes build failures on Snow Leopard.
    ENV.cxx11 if build.cxx11?

    # Fixes build error with clang, old libtool scripts. cf. #12127
    # Reported upstream here: https://issues.apache.org/jira/browse/LOGCXX-396
    # Remove at: unknown, waiting for developer comments.
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Docs won't install on OS X
                          "--disable-doxygen"
    system "make", "install"
  end
end
