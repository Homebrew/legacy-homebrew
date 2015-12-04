class Pacvim < Formula
  desc "Learn vim commands via a game"
  homepage "https://github.com/jmoon018/PacVim"
  url "https://github.com/jmoon018/PacVim/archive/v1.1.1.tar.gz"
  sha256 "c869c5450fbafdfe8ba8a8a9bba3718775926f276f0552052dcfa090d21acb28"
  head "https://github.com/jmoon018/PacVim.git"

  bottle do
    sha256 "36b138084ac97f4eb28bc6b7068e19dc28cc478459fc59de12e8e849820ac65d" => :yosemite
    sha256 "1f5e908420b40f2af868727b7065a51ebc39525c241b983f7f9b9449b95fdc1c" => :mavericks
    sha256 "13f43d00b08183febdc7afcba0553cd512dd9ae23a7fd770b09e3eedb4f8ea37" => :mountain_lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "PREFIX=#{prefix}"
  end
end
