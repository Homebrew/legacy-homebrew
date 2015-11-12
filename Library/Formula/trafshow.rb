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
    "domain_resolver.c" => "43b97d4ea025ed2087e4525a0b1acffc887082148df6dd2603b91fa70f79b678",
    "colormask.c"       => "04121b295d22a18aaf078611c75401a620570fbd89362bba2dd1abc042ea3c4a",
    "trafshow.c"        => "3164a612689d8ec310453a50fbb728f9bae3c356b88c41b6eab7ba7e925b1bf1",
    "trafshow.1"        => "8072e52acc56dd6f64c75f5d2e8a814431404b3fdfbc15149aaad1d469c47ff1",
    "configure"         => "c6e34dddd6c159cbd373b2b593f7643642cb10449c6bc6c606e160586bc5b794",
  }.each do |name, sha|
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/be6fd4a/trafshow/patch-#{name}"
      sha256 sha
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
