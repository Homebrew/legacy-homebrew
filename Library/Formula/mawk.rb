class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "http://invisible-island.net/mawk/"
  url "ftp://invisible-island.net/mawk/mawk-1.3.4-20141027.tgz"
  sha256 "a88f50c1a0800ae6d2cedb0672b15bd32cc57e482715ca7c1471fb398e89767a"

  bottle do
    cellar :any
    sha256 "d513669dc87cf81fc1526d1784191f613837b871bde25e2a3eaaa0b7f0d991ad" => :yosemite
    sha256 "e116bc17922da25b037f2b5cf15f93cf0f8f535efe5fc3435cf337af10f553e7" => :mavericks
    sha256 "3d38eee059da9baa8aa70feb54b9e1eeaff8023b80bea0dfcd482039ee971476" => :mountain_lion
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
