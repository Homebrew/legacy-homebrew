require "formula"

class Capnp < Formula
  homepage "http://kentonv.github.io/capnproto/"
  url "http://capnproto.org/capnproto-c++-0.5.0.tar.gz"
  sha1 "5eec5929d9b64628b2e7b6646369f112079a1f61"

  bottle do
    cellar :any
    sha1 "e980920f619a0682b1335550844b065894ed43ac" => :yosemite
    sha1 "37a57c4a451723d7aa63dce453d35c65dce38a6e" => :mavericks
    sha1 "8d7cc81fe1e7356eea9b422cc59ecbb1cef8f808" => :mountain_lion
  end

  needs :cxx11
  option "without-shared", "Disable building shared library variant"

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]

    args << "--disable-shared" if build.without? "shared"

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end
