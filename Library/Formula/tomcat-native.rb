class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.2/source/tomcat-native-1.2.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.2/source/tomcat-native-1.2.2-src.tar.gz"
  sha256 "9bd4deb1a816efda8208bfb4f55ee1689571e1d05a5c1e84faf2ad1021a9cae6"

  bottle do
    cellar :any
    sha256 "e9e472d50ff1c5edfd2c02bd57db7d8412f607250ae759614c9689289e922ffb" => :el_capitan
    sha256 "75d6f31a1618f29d8d98efb69afacc3cdf310ee683f21ff4ba18ee2dee666e57" => :yosemite
    sha256 "5ea0be1d91ab2c69bc51ead44cd460fdd2dbd07f5175e6038d9d711a8c2b8d89" => :mavericks
  end

  option "with-apr", "Include APR support via Homebrew"

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7+"
  depends_on "openssl"
  depends_on "apr" => :optional

  def install
    cd "native" do
      if build.with? "apr"
        apr_path = Formula["apr"].opt_prefix
      else
        apr_path = "#{MacOS.sdk_path}/usr"
      end
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{apr_path}",
                            "--with-java-home=#{ENV["JAVA_HOME"]}",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125: /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc: No such file or directory
      args << "CC=#{ENV.cc}" if MacOS.version >= :mountain_lion
      system "make", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    In order for tomcat's APR lifecycle listener to find this library, you'll
    need to add it to java.library.path. This can be done by adding this line
    to $CATALINA_HOME/bin/setenv.sh

      CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{lib}\"

    If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
