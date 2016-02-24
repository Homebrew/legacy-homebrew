class Trafshow < Formula
  desc "Continuous network traffic display"
  homepage "http://soft.risp.ru/trafshow/index_en.shtml"
  url "http://distcache.freebsd.org/ports-distfiles/trafshow-5.2.3.tgz"
  sha256 "ea7e22674a66afcc7174779d0f803c1f25b42271973b4f75fab293b8d7db11fc"

  bottle do
    cellar :any
    sha256 "b09387706ec1b936ded262d795d2371a9e5f9682c06ee4d32e7d434a2291dea9" => :mavericks
    sha256 "9df6fd0a83650199c086577968ad5d89d66ebf5d7c947064c63f061bf28cbe10" => :mountain_lion
    sha256 "3783dc9d296d39390c792a347a72b9bebac5ab73a1e0b242af406d5505b0dc4f" => :lion
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
