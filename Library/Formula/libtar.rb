class Libtar < Formula
  desc "C library for manipulating POSIX tar files"
  homepage "http://repo.or.cz/w/libtar.git"
  url "http://repo.or.cz/libtar.git",
      :tag => "v1.2.20",
      :revision => "0907a9034eaf2a57e8e4a9439f793f3f05d446cd"

  bottle do
    cellar :any
    revision 1
    sha1 "18d378564e3507204dd29e84bf09840e335206a2" => :yosemite
    sha1 "bcbd1747ca7827d795a13d11648d72ecb5b5e1a2" => :mavericks
    sha1 "96e778eed9bba1d3cfd8fbc81e616ad580770a84" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "This is a simple example"
    system "tar", "-cvf", "test.tar", "homebrew.txt"
    rm "homebrew.txt"
    assert !File.exist?("homebrew.txt")
    assert File.exist?("test.tar")

    system bin/"libtar", "-x", "test.tar"
    assert File.exist?("homebrew.txt")
  end
end
