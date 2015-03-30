class JdkDownloadStrategy < CurlDownloadStrategy
  def _fetch
    raise "On Mac OS try instead `brew cask install java`" if OS.mac?
    curl @url, "-C", downloaded_size, "-o", temporary_path,
      "--cookie", "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk < Formula
  homepage "http://www.java.com/"

  version "1.8.0-40"
  if OS.linux?
    url "http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.tar.gz",
      :using => JdkDownloadStrategy
    sha256 "da1ad819ce7b7ec528264f831d88afaa5db34b7955e45422a7e380b1ead6b04d"
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
