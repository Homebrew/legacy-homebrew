require 'formula'

class TomcatNative < Formula
  homepage 'http://tomcat.apache.org/native-doc/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.1.31/source/tomcat-native-1.1.31-src.tar.gz'
  sha1 '177b1f43f3dbc16eeea39d85147355be29a6089f'

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7"
  depends_on "openssl"

  def install
    cd "jni/native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{MacOS.sdk_path}/usr",
                            "--with-java-home=#{`/usr/libexec/java_home`.chomp}",
                            "--with-ssl=#{Formula["openssl"].prefix}"

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
