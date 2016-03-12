class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "http://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "http://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"

  bottle do
    cellar :any
    sha256 "5009146ed4f0af8dda5c687f2a615005e848348f82fd8acdd25aa3805b8e4d94" => :yosemite
    sha256 "05f9056dc9bb3e4e77b1ea54346a52508930bdd9a357dc1e368227969f183905" => :mavericks
    sha256 "8d4ce6951a4dd81a3dc23859be07a48cd0ebd72a5a3d758ce54318b208378b0e" => :mountain_lion
  end

  option :universal

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/with-readline /usr/bin/expect", "exit", 0)
  end
end
