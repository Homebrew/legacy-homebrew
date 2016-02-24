class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "http://www.gentoo.com/di/"
  url "http://gentoo.com/di/di-4.36.tar.gz"
  sha256 "eb03d2ac0a3df531cdcb64b3667dbaebede60a4d3a4626393639cecb954c6d86"

  bottle do
    cellar :any_skip_relocation
    sha256 "088b843fb5b82aa978f8cfe3ae0d90dbac7811b326a6dd9be027e3bbc740b706" => :el_capitan
    sha256 "aec4d32a7d6930610423b7a9d72033e996a2f50bfe54d1cb778ca55dca5d243d" => :yosemite
    sha256 "00958ab5af10860c7d7283d7e240f03a56d27f85d36a89872740e7391609e203" => :mavericks
    sha256 "ad54d80a30189a79074d05e4e79ac7ef5fa4436c217866dea2382b351ec44127" => :mountain_lion
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
