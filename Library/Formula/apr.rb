class Apr < Formula
  homepage "https://apr.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=apr/apr-1.5.2.tar.bz2"
  sha1 "6d757fcf7c687fc300c1066076f2e8380ff8cbc0"

  bottle do
    sha1 "dd876e8523f31e935a605c3cb710d681aa762ae7" => :yosemite
    sha1 "881def6c18b664e2d3cc88f1e8c975fb314bb105" => :mavericks
    sha1 "48905e0fc63b2ae63cd3fd0912cec8ea09441420" => :mountain_lion
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal

  def install
    ENV.universal_binary if build.universal?

    # https://issues.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/apr-1-config", "--link-libtool", "--libs"
  end
end
