class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://unix4lyfe.org/darkstat/darkstat-3.0.718.tar.bz2"
  sha256 "682f3e53f4e89ea6ad08236b4225a5e0859428299765d8d995374cd7fa22adff"

  bottle do
    cellar :any
    sha256 "149200f26467aa269ddea52f85a59af1439a73f923f7282ec2b5e7185116bfe3" => :yosemite
    sha256 "d82fe76abca04e5928ea0923e8a4927262091ed40f86cf0f2822cb7ac72ced0d" => :mavericks
    sha256 "a1532b5219ce54e9a6609f3b717fa83b23de163d033553d7d784573143385138" => :mountain_lion
  end

  devel do
    url "https://unix4lyfe.org/darkstat/darkstat-3.0.719rc1.tar.bz2"
    sha256 "827e91aa9261d3f6783cf3f8affa80590800cc5740dcac5f42c88e2bc781390b"
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
