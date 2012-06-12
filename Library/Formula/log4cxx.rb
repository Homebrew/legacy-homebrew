require 'formula'

class Log4cxx < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz'
  homepage 'http://logging.apache.org/log4cxx/index.html'
  md5 'b30ffb8da3665178e68940ff7a61084c'

  fails_with :llvm do
    build 2334
    cause "Fails with 'collect2: ld terminated with signal 11 [Segmentation fault]'"
  end

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [
      ["--universal", "Build for both 32 & 64 bit Intel."]
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    ENV.O2 # Using -Os causes build failures on Snow Leopard.

    # Fixes build error with clang, old libtool scripts. cf. #12127
    # Reported upstream here: https://issues.apache.org/jira/browse/LOGCXX-396
    # Remove at: unknown, waiting for developer comments.
    system './autogen.sh'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Docs won't install on OS X
                          "--disable-doxygen"
    system "make install"
  end
end
