class Libbson < Formula
  desc "BSON utility library"
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.1.7/libbson-1.1.7.tar.gz"
  sha256 "94b11f9ce0bc118b9f4dc0470ce48aaf673278f4b22517c452e1f3f675d1abe3"

  bottle do
    cellar :any
    sha256 "0fe2c73915572317e0e708bfe387fb3320ac8474afc4173b70d0b018ec0bdb33" => :el_capitan
    sha256 "00c6bf92d3d324c39fce886b061de737090ea98f3cadf02a360857ac0f302dc6" => :yosemite
    sha256 "78e2c2b112d80180c5578f9a1581b68bfd73d2fe7561903d2b4e177ccdd8932d" => :mavericks
    sha256 "5fd3ce491e4a7c7980359b9870d74d2ed7f90f35876d7de28ffd50f6c3e8eaff" => :mountain_lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
