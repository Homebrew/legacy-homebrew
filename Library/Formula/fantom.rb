require 'formula'

class Fantom < Formula
  homepage 'http://fantom.org'
  url 'http://fan.googlecode.com/files/fantom-1.0.65.zip'
  sha1 'f88852a680b91963d8df7136fbcfe9ff54a5bb94'

  option 'with-src', 'Also install fantom source'
  option 'with-examples', 'Also install fantom examples'

  # Select the OS X JDK path in the config file
  def patches; DATA; end

  def install
    rm_f Dir["bin/*.exe", "lib/dotnet/*"]
    rm_rf "examples" unless build.include? 'with-examples'
    rm_rf "src" unless build.include? 'with-src'

    libexec.install Dir['*']
    system "chmod 0755 #{libexec}/bin/*"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end

__END__
diff --git a/etc/build/config.props b/etc/build/config.props
index 368bce3..ebbff42 100755
--- a/etc/build/config.props
+++ b/etc/build/config.props    
@@ -22,8 +22,8 @@ buildVersion=1.0.65
 javacParams=-target 1.5
 
 // Windows setup
-jdkHome=/C:/Program Files/Java/jdk1.6/
-dotnetHome=/C:/WINDOWS/Microsoft.NET/Framework/v2.0.50727/
+//jdkHome=/C:/Program Files/Java/jdk1.6/
+//dotnetHome=/C:/WINDOWS/Microsoft.NET/Framework/v2.0.50727/
 
 // Mac setup
-//jdkHome=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home/
\ No newline at end of file
+jdkHome=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home/
\ No newline at end of file


