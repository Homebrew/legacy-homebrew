class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://unix4lyfe.org/darkstat/darkstat-3.0.719.tar.bz2"
  sha256 "aeaf909585f7f43dc032a75328fdb62114e58405b06a92a13c0d3653236dedd7"

  bottle do
    cellar :any
    sha256 "149200f26467aa269ddea52f85a59af1439a73f923f7282ec2b5e7185116bfe3" => :yosemite
    sha256 "d82fe76abca04e5928ea0923e8a4927262091ed40f86cf0f2822cb7ac72ced0d" => :mavericks
    sha256 "a1532b5219ce54e9a6609f3b717fa83b23de163d033553d7d784573143385138" => :mountain_lion
  end

  head do
    url "https://www.unix4lyfe.org/git/darkstat", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
