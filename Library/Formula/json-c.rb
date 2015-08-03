class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.12-20140410.tar.gz"
  version "0.12"
  sha256 "99304a4a633f1ee281d6a521155a182824dd995139d5ed6ee5c93093c281092b"

  bottle do
    cellar :any
    revision 1
    sha1 "fda8051afcd1aca5d5f225a757c0f6333c9f091a" => :yosemite
    sha1 "3e4ba1c8434dde4bcff70dbfa5be90a1f8540f3f" => :mavericks
    sha1 "e4b48b569408080805e236317eec4fa0cc3c2f06" => :mountain_lion
  end

  head do
    url "https://github.com/json-c/json-c.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end
end
