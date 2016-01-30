class Bbe < Formula
  desc "Sed-like editor for binary files"
  homepage "http://sourceforge.net/projects/bbe-/"
  url "https://downloads.sourceforge.net/project/bbe-/bbe/0.2.2/bbe-0.2.2.tar.gz"
  sha256 "baaeaf5775a6d9bceb594ea100c8f45a677a0a7d07529fa573ba0842226edddb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9c63d7b9657e6f1c0e53048564f275283177e3513e202a7a9cfc69571bb5008" => :el_capitan
    sha256 "ae0aa826fcd9f11e93428e9eaeedb14a56c193c861f09123999a8ba0f3d7f9cd" => :yosemite
    sha256 "6b7c4c2c05ab444212260dfef6b2ab2ed7e9230844007651217259d1f957ed02" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
