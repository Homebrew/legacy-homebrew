class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "http://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git", :tag => "v0.3",
      :revision => "63e89e92164d5f527a8e2bbec08797179b2dacb1"

  bottle do
    cellar :any
    sha256 "c730306d9053f007178149525392d736b238faf45e85f88f9d1c8e8a098daaad" => :yosemite
    sha256 "a952db97c0d9629820ab495f0276a00877b13e1c7f39af230970417a9b5691a9" => :mavericks
    sha256 "89f944d8fde6f621d5f2ec817b91c349e0a34ade67a0600e98b905d92b50e013" => :mountain_lion
  end

  head "https://github.com/tracebox/tracebox.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"
  depends_on "json-c"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
    EOS
  end
end
