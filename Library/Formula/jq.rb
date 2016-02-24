class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"

  bottle do
    cellar :any
    revision 1
    sha256 "d969487931abc27767a3435f5a1b2d06ed61aab0916de187ed894b6137baceee" => :el_capitan
    sha256 "8529bc1edac66bdeec82afe80ce671b9d015b02959fe9f37efd2887fd975faf1" => :yosemite
    sha256 "89a32fb53e7f4330d6db84ba526133228189ea3ba3b15adf7fc743787c8ef645" => :mavericks
    sha256 "d817dec8745f52802b4ac2fbcd2a7a76a647b2000f43ba9a842f59a4363da55d" => :mountain_lion
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"  # jq depends > 1.5
  depends_on "bison" => :build # jq depends on bison > 2.5

  def install
    system "autoreconf", "-iv" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
