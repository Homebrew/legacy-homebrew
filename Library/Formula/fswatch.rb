require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.2/fswatch-1.4.2.zip"
  sha1 "df3a4a8bfca8c06f2e42cb6ee73f3f522b1dc3af"

  bottle do
    sha1 "797eb30eb5acb5599e712d9635e3e106a0d58d6f" => :mavericks
    sha1 "c560900c86bf37ceeb850e40edd2b3e8350400e9" => :mountain_lion
    sha1 "ba5181a3bac04e0199124a9eaa97673e84f6b8bf" => :lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
