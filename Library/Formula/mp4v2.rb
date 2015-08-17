class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://code.google.com/p/mp4v2/"
  url "https://mp4v2.googlecode.com/files/mp4v2-2.0.0.tar.bz2"
  sha256 "0319b9a60b667cf10ee0ec7505eb7bdc0a2e21ca7a93db96ec5bd758e3428338"

  bottle do
    cellar :any
    revision 1
    sha1 "7cdf66572d30457b9ccde22e5adb254f8423372a" => :yosemite
    sha1 "423dc3e6a70da565233d7093a82089aa725d021e" => :mavericks
    sha1 "7adca200e0baf9cd0ba94acec0417d6a5dc74ad9" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make install-man"
  end
end
