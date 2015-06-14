class Nutcracker < Formula
  desc "Proxy for memcached and redis"
  homepage "https://github.com/twitter/twemproxy"
  url "https://github.com/twitter/twemproxy/archive/v0.4.0.tar.gz"
  sha1 "7bc17d4d78196abeac27c8544efd833849d03f48"
  head "https://github.com/twitter/twemproxy.git"

  bottle do
    cellar :any
    sha256 "369a87e5fc60849e8fb1b40f8df1f57406f7b86fbb7b2b5503b3b1a75fc1ecfd" => :yosemite
    sha256 "603e6a29b7f3c80680aa811e80e52ddbf5c5b35aa676d363ac79cdd254489d16" => :mavericks
    sha256 "58e30a2d345c686e6cecb492a8356d9696d9200481c55fabc7460a55ae24e162" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (share+"nutcracker").install "conf",  "notes", "scripts"
  end

  test do
    system "#{opt_sbin}/nutcracker", "-V"
  end
end
