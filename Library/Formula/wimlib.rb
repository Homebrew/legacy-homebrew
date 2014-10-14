require "formula"

class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.7.1.tar.gz"
  sha1 "ffbd2f138b396b0f1fb684294747d9c8b5421188"

  bottle do
    cellar :any
    sha1 "6ca564aa9658b05c28b6544e155e13676a893571" => :mavericks
    sha1 "c9c0b1b06c06b252e984dbe9bb5a6ad123cde482" => :mountain_lion
    sha1 "be55a5ac5065bc29e6f0f406c7a73ee755339674" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "ntfs-3g"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-fuse", # requires librt, unavailable on OSX
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"wiminfo", "--help"
  end
end
