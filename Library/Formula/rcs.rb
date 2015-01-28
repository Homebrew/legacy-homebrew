class Rcs < Formula
  homepage "https://www.gnu.org/software/rcs/"
  url "http://ftpmirror.gnu.org/rcs/rcs-5.9.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.9.4.tar.xz"
  sha1 "e87fb2e587fa165204ef69f69b7d5cd354c4e44d"

  bottle do
    cellar :any
    revision 1
    sha1 "9c2f2518aa1ffe52fa0a190d895c095078ab3a48" => :yosemite
    sha1 "cff1c3e3090bbdcd980bc7faf333916872e0bf19" => :mavericks
    sha1 "7ef0f63b4ddb1ad0ebfb2d72d15d4317018943f7" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
