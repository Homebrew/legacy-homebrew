require 'formula'

class TomcatNative < Formula
  homepage 'http://tomcat.apache.org/native-doc/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.1.29/source/tomcat-native-1.1.29-src.tar.gz'
  sha1 '16ce3eaee7a4c26f4a6fdd89eece83501d12b754'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version (required for TLSv1.1/TLSv1.2)'

  depends_on :libtool => :build
  depends_on 'tomcat' => :recommended
  depends_on 'openssl' if build.with? 'brewed-openssl'

  def install
    cd "jni/native/" do
      args = %W[
        --prefix=#{prefix}
        --with-apr=#{MacOS.sdk_path}/usr
        --with-java-home=/System/Library/Frameworks/JavaVM.framework/
      ]
      args << ((build.with? 'brewed-openssl') ? "--with-ssl=#{Formula.factory('openssl').prefix}" : "--with-ssl=#{MacOS.sdk_path}/usr")
      system "./configure", *args
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
    You have to symlink Apache Tomcat Native to /Library/Java/Extensions to be recognized by Apache Tomcat:
      sudo ln -fs #{lib}/libtcnative-1.* /Library/Java/Extensions
    EOS
  end
end
