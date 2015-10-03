class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "http://invisible-island.net/mawk/"
  url "ftp://invisible-island.net/mawk/mawk-1.3.4-20141027.tgz"
  sha256 "a88f50c1a0800ae6d2cedb0672b15bd32cc57e482715ca7c1471fb398e89767a"

  bottle do
    cellar :any
    sha1 "32fbaf50a142eba4ce968a0de1cc013cd2d39f66" => :yosemite
    sha1 "9d733323a1e4e185ad6e9cf5a45139258f14ed37" => :mavericks
    sha1 "169c70e2d8b83c9c19ebc97687278044fd8c855d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    version=`mawk '/version/ { print $2 }' #{prefix}/README`
    assert_equal 0, $?.exitstatus
    assert_equal version, "#{version}"
  end
end
