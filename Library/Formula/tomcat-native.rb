require 'formula'

class TomcatNative < Formula
  homepage 'https://tomcat.apache.org/native-doc/'
  url 'https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.1.33/source/tomcat-native-1.1.33-src.tar.gz'
  sha1 'c7626c8e5144ee8e958175c4cd034cef90eab1ed'

  bottle do
    cellar :any
    sha256 "1649e2b91dab7a9d2f3399fa713478f5a68f8b55a5a59a5007257797c4611386" => :yosemite
  end

  option "with-apr", "Include APR support via Homebrew"

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7"
  depends_on "openssl"
  depends_on "apr" => :optional

  def install
    cd "jni/native" do
      if build.with? 'apr'
        apr_path = Formula['apr'].opt_prefix
      else
        apr_path = "#{MacOS.sdk_path}/usr"
      end
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{apr_path}",
                            "--with-java-home=#{`/usr/libexec/java_home`.chomp}",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125: /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc: No such file or directory
      args << "CC=#{ENV.cc}" if MacOS.version >= :mountain_lion
      system "make", *args
      system "make install"
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
