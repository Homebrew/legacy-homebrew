class Rdate < Formula
  desc "Set the system's date from a remote host"
  homepage "https://www.aelius.com/njh/rdate/"
  url "https://www.aelius.com/njh/rdate/rdate-1.5.tar.gz"
  sha256 "6e800053eaac2b21ff4486ec42f0aca7214941c7e5fceedd593fa0be99b9227d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "acb2ae5951a0f32cbdce39e02d86c63cdb85b41fd02aff74aac6ea4939d71d8d" => :el_capitan
    sha256 "553782017635be9c8d80bbf6fd033f294cddcb427a2d83fe82af8c069c60867f" => :yosemite
    sha256 "3a36b6feccd119c90db3373a3de1b67f4aa03fc72aacdf7b11165b538206ae14" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rdate", "-p", "-t", "2", "0.pool.ntp.org"
  end
end
