class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "http://fribidi.org/"
  url "http://fribidi.org/download/fribidi-0.19.7.tar.bz2"
  sha256 "08222a6212bbc2276a2d55c3bf370109ae4a35b689acbc66571ad2a670595a8e"

  bottle do
    cellar :any
    sha256 "cb0bfe8325e4f8080bb6035f33a71af75482b9d6ca9b7b1f0acb8581a888df9e" => :yosemite
    sha256 "2aba6a847848ca88141dbe840ff3465cb882d6c7f7b2951d39ac88abc0d3e578" => :mavericks
    sha256 "1bc5b4d99f7d9efd38f1ca3e36f24c69c0a39751d4633d842d110065b4eca036" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<-EOS.undent
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
