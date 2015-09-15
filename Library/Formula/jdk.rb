class JdkDownloadStrategy < CurlDownloadStrategy
  def _fetch
    raise "On Mac OS try instead `brew cask install java`" if OS.mac?
    curl @url, "-C", downloaded_size, "-o", temporary_path,
      "--cookie", "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk < Formula
  homepage "http://www.java.com/"

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
