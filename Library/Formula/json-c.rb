class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.12-20140410.tar.gz"
  version "0.12"
  sha256 "99304a4a633f1ee281d6a521155a182824dd995139d5ed6ee5c93093c281092b"

  bottle do
    cellar :any
    revision 1
    sha256 "8ba8006e2eb97006a781ce8d93a95791ae1e26d094afce0aeb8483caa95febbd" => :el_capitan
    sha256 "f7a602faf71091f98eb7b8390c1bd36bbd14cfe7e20c2f418bcc5c797315a2be" => :yosemite
    sha256 "e755df0edf95cf76c20a551dd28bb1703e769371413feaa7f60660338a72ce6c" => :mavericks
    sha256 "df94de81086ff76a48531df981ea32390dbae338e93fc0e157efc97193cd1f74" => :mountain_lion
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
