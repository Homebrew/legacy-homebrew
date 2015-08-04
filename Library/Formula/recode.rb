class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "http://recode.progiciels-bpi.ca/index.html"
  url "https://github.com/pinard/Recode/archive/v3.7-beta2.tar.gz"
  sha256 "72c3c0abcfe2887b83a8f27853a9df75d7e94a9ebacb152892cc4f25108e2144"
  version "3.7-beta2"

  depends_on "gettext"
  depends_on "libtool" => :build

  def install
    # Yep, missing symbol errors without these
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lintl"

    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-included-gettext",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
