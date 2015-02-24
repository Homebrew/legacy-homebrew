require "formula"

class Cpanminus < Formula
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7022.tar.gz"
  sha1 "ce2e5321d676022b9e476bb8e5683ad60e13915c"

  head "https://github.com/miyagawa/cpanminus.git"

  bottle do
    cellar :any
    sha1 "52f75e63756ef4c858013fa3542ce138e899f904" => :yosemite
    sha1 "2457a4bcbee3e5ba9dd6fd5717477b6fffe5dde9" => :mavericks
    sha1 "8ee611a85ab2f397f810a4f92f9d5af987a3789f" => :mountain_lion
  end

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "-V"
  end
end
