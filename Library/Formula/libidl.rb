class Libidl < Formula
  desc "libIDL is a library for creating CORBA IDL files"
  homepage "http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/"
  url "https://download.gnome.org/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2"
  sha256 "c5d24d8c096546353fbc7cedf208392d5a02afe9d56ebcc1cccb258d7c4d2220"

  bottle do
    cellar :any
    revision 1
    sha256 "356ad466ab477116e8f030ef75b70bc46321f68ec1f077f9b06dca3bb076e499" => :yosemite
    sha256 "dffe56b6e1076ac49a43ff662517b974f97e47707906362629176cfdc09b6f91" => :mavericks
    sha256 "7aee2ea7f3760687e9acd4a35c393e240f8f59e94a36c2a31812d15a41cfcac8" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
