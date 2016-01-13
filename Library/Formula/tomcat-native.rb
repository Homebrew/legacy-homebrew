class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.4/source/tomcat-native-1.2.4-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.4/source/tomcat-native-1.2.4-src.tar.gz"
  sha256 "29d53d4646229a839ccb71b7b3caa25c256aab1965c33cc9d140247213b9b171"

  bottle do
    cellar :any
    sha256 "8ce2e7b4ad961da4867cce166945df037c8d76e826d43a93c3d8cfb0f8d68f89" => :el_capitan
    sha256 "2352fe2f08e07aad55be01da7be1652817e3edc81868bca9356a7fde000b16af" => :yosemite
    sha256 "3446580b48a5591bed7366a81003a1e0f8fccbfdb4687a023acc953f5efffb92" => :mavericks
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
