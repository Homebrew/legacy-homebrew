class Pev < Formula
  desc "PE analysis toolkit"
  homepage "http://pev.sf.net/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.70/pev-0.70.tar.gz"
  sha256 "250396a06930d60a92e9bc86d7afb543d899ba12c007d1be5d09802a02908202"
  revision 1

  head "https://github.com/merces/pev.git"

  bottle do
    cellar :any
    sha256 "e01f09a92f3af2fb454e17529bac7900978960382bc52ae62aa4fa6b751f41c0" => :yosemite
    sha256 "f2ffcbda87b08fdd2a4621468f711c7f5542b2413833f350f93105d0825a97d9" => :mavericks
    sha256 "08ba1dbebcb68b2c6a67a2052840764803ad3efc975563e72960da0f8b6e463d" => :mountain_lion
  end

  depends_on "pcre"
  depends_on "openssl"

  def install
    inreplace "src/Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "SHAREDIR", share
      s.change_make_var! "MANDIR", man
    end

    inreplace "lib/libpe/Makefile" do |s|
      s.gsub! "/usr", prefix
    end

    system "make", "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
