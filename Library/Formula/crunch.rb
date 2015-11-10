class Crunch < Formula
  desc "Wordlist generator"
  homepage "http://sourceforge.net/projects/crunch-wordlist"
  url "https://downloads.sourceforge.net/project/crunch-wordlist/crunch-wordlist/crunch-3.6.tgz"
  sha256 "6a8f6c3c7410cc1930e6854d1dadc6691bfef138760509b33722ff2de133fe55"

  bottle do
    cellar :any_skip_relocation
    sha256 "aeb95600638a9225123171f528b485d6380aca6ef087ed092eebe6ade368d9a2" => :el_capitan
    sha256 "4040ca2e70a628a6467b56cc90be8781741c91649db7045187becc0c318d362e" => :yosemite
    sha256 "2862007c837b4fd05950b1b6059879346de82de91b042953fd2a783476b2016b" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}", "LFS=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

    bin.install "crunch"
    man1.install "crunch.1"
    share.install Dir["*.lst"]
  end
end
