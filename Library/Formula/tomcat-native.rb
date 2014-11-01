require 'formula'

class TomcatNative < Formula
  homepage 'http://tomcat.apache.org/native-doc/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.1.32/source/tomcat-native-1.1.32-src.tar.gz'
  sha1 'a4bfb7f79316c49cfed3a0c5c71ba11b51fe0922'

  bottle do
    cellar :any
    sha1 "2294b2ecde5a96eb38e28223d622d5c443c9a04b" => :yosemite
    sha1 "04e8e6d8de9064eeacbf06101a029a2463de4649" => :mavericks
    sha1 "03d417ff8af69aba03c872e3bf7b3de9ca43d44b" => :mountain_lion
  end

  option "with-apr", "Include APR support via Homebrew"

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7"
  depends_on "openssl"
  depends_on "homebrew/apache/apr" => :optional

  def install
    cd "jni/native" do
      if build.with? 'apr'
        apr_path = "#{Formula['homebrew/apache/apr'].prefix}"
      else
        apr_path = "#{MacOS.sdk_path}/usr"
      end
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{apr_path}",
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
