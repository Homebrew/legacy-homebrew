require "formula"

class JdkDownloadStrategy < CurlDownloadStrategy
  def _fetch
    curl @url, "-C", downloaded_size, "-o", temporary_path,
      "--cookie", "oraclelicense=accept-securebackup-cookie"
  end
end

class Jdk < Formula
  homepage "http://www.java.com/"

  version "1.8.0-25"
  if OS.linux?
    url "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz",
      :using => JdkDownloadStrategy
    sha1 "0eb0448641c21c435cddc4705d23668d45f29fff"
  elsif OS.mac?
    raise "On Mac OS try instead `brew cask install java`"
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
