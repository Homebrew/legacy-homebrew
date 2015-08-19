class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "http://ftpmirror.gnu.org/libidn/libidn-1.32.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.32.tar.gz"
  sha256 "ba5d5afee2beff703a34ee094668da5c6ea5afa38784cebba8924105e185c4f5"

  bottle do
    cellar :any
    sha256 "394815d83ce8d4a624f850b1937460f8aa480eaf5ab24e3913ae9f97b58ef5cc" => :yosemite
    sha256 "a6d772eaae49a7062907154fa823c29100ad909a84341a0daddfeaff8ea92019" => :mavericks
    sha256 "fc0e7b0ffa3ba0c0eb3445427acfdd15fa50c868dda89cf17b471030251a3555" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{share}/emacs/site-lisp/#{name}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system "#{bin}/idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
