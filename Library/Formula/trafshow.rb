class Trafshow < Formula
  desc "Continuous network traffic display"
  homepage "http://soft.risp.ru/trafshow/index_en.shtml"
  url "http://distcache.freebsd.org/ports-distfiles/trafshow-5.2.3.tgz"
  sha256 "ea7e22674a66afcc7174779d0f803c1f25b42271973b4f75fab293b8d7db11fc"

  bottle do
    cellar :any
    sha1 "c41e1061e5300760e840f7cfde4ae669b24800e8" => :mavericks
    sha1 "13881774f1b3a0ba6886dda9fe12aea126f2fefd" => :mountain_lion
    sha1 "86097cbc1a851ae8a07b591ef6da823926b132cc" => :lion
  end

  depends_on "libtool" => :build

  {
    "domain_resolver.c" => "1e7b470e65ed5df0a5ab2b8c52309d19430a6b9b",
    "colormask.c"       => "25086973e067eb205b67c63014b188af3b3477ab",
    "trafshow.c"        => "3a7f7e1cd740c8f027dee7e0d5f9d614b83984f2",
    "trafshow.1"        => "99c1d930049b261a5848c34b647d21e6980fa671",
    "configure"         => "94e9667a86f11432e3458fae6acc593db75936b5"
  }.each do |name, sha|
    patch :p0 do
      url "https://trac.macports.org/export/68507/trunk/dports/net/trafshow/files/patch-#{name}"
      sha1 sha
    end
  end

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-slang"
    system "make"

    bin.install "trafshow"
    man1.install "trafshow.1"
    etc.install ".trafshow" => "trafshow.default"
  end
end
