class Gistit < Formula
  desc "Command-line utility for creating Gists"
  homepage "https://gistit.herokuapp.com/"
  url "https://github.com/jrbasso/gistit/archive/v0.1.3.tar.gz"
  sha256 "b7203c318460c264bd19b35a767da1cef33e5cae2c65b057e401fe20f47e1cca"

  head "https://github.com/jrbasso/gistit.git"

  bottle do
    cellar :any
    sha256 "052536cb990d1c5ea4b48612026dfb13addd03cbc06ed8c6b42f3636eb6771a7" => :yosemite
    sha256 "c2388d390d86f39934ae51e71edfa1fd890d8ad4384427ab14275280eece97ce" => :mavericks
    sha256 "a937902abd77953fa61689cb8bdb58344cf0d8a20e36bf1745f31fac9beb14b8" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jansson"

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gistit", "-v"
  end
end
