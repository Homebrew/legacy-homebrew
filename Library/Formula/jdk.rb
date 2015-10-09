class JdkDownloadStrategy < CurlDownloadStrategy
  def _curl_opts
    super << "--cookie" << "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk < Formula
  homepage "http://www.oracle.com/technetwork/java/javase/downloads/index.html"

  version "1.8.0-60"
  if OS.linux?
    url "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz",
      :using => JdkDownloadStrategy
    sha256 "ebe51554d2f6c617a4ae8fc9a8742276e65af01bd273e96848b262b3c05424e5"
  elsif OS.mac?
    url "jdk", :using => JdkDownloadStrategy
  else
    raise "Unknown operating system"
  end

  def install
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    By installing and using JDK you agree to the
    Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX
    http://www.oracle.com/technetwork/java/javase/terms/license/index.html
    EOS
  end

  test do
    system "#{bin}/java", "-version"
    system "#{bin}/javac", "-version"
  end
end
