require 'formula'
#note that you have to 'brew tap homebrew/dupes' on Mountain Lion before installing this Forula!
class TomcatNative < Formula
  homepage 'http://tomcat.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.1.27/source/tomcat-native-1.1.27-src.tar.gz'
  sha1 '344151b3935294c7e61c615a418ac654e12c899e'

  option 'without-openssl', "Build without ssl support"
  option 'with-brewed-openssl', "Use Homebrew's openSSL instead of the one from OS X (default for Mountain Lion)"
  #You have to set this on Mountain Lion since non-excistent paths in apr-1-config and libtool: https://github.com/fgeller/homebrew/commit/8bfcbb4
  #Otherwise you will get this error: env: /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc: No such file or directory
  option 'with-brewed-apr', "Use apr Homebrew dupes instead the apr from OS X (default for Mountain Lion)"
  option 'with-mountain-lion-apr-fix', "Not working yet, try to fixed the issue with apr-1-config in Montain Lion"

  depends_on 'tomcat'
  depends_on 'openssl' if build.include? 'with-brewed-openssl' or MacOS.version >= :mountain_lion
  depends_on 'homebrew/dupes/apr' if build.include? 'with-brewed-apr' or MacOS.version >= :mountain_lion

  def apr_bin
    superbin or "/usr/bin"
  end

  def install
    cd "jni/native/" do
      args = ["--with-java-home=/System/Library/Frameworks/JavaVM.framework/", "--prefix=#{prefix}"]
      
      if build.include? 'with-brewed-apr' or MacOS.version >= :mountain_lion
        args << "--with-apr=#{Formula.factory('apr').prefix}"
      elsif build.include? 'with-mountain-lion-apr-fix'
        args << "--with-apr=#{apr_bin}" #fixed not all errors :(
      else
        args << "--with-apr=/usr"
      end
      
      if build.include? 'without-openssl'
        args << "--disable-openssl"
      elsif build.include? 'with-brewed-openssl' or MacOS.version >= :mountain_lion
          args << "--with-ssl=#{Formula.factory('openssl').prefix}"
      else
        args << "--with-ssl=/usr"
      end
      system "./configure", *args
      system "make install"
    end
  end
  
  def caveats;
    if build.include? 'without-openssl' and build.include? 'with-brewed-openssl'
      <<-EOS.undent
        Your with-brewed-openssl option was ignored, because the without-ssl option was set.
      EOS
    end
    <<-EOS.undent
      You have to symlink Apache Tomcat Native to /usr/lib/java to be recognized by Apache Tomcat.
      sudo ln -s #{prefix}/lib/libtcnative-1.0.dylib /usr/lib/java/libtcnative-1.dylib
      sudo ln -s #{prefix}/lib/libtcnative-1.0.dylib /usr/lib/java/libtcnative-1.jnilib
    EOS
  end
end