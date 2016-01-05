class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "http://rsnapshot.org"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.2/rsnapshot-1.4.2.tar.gz"
  sha256 "042a81c45b325296b21c363f417985d857f083f87c5c27f5a64677a052f24e16"

  head "https://github.com/DrHyde/rsnapshot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21823489c045150e8d8e51addba52b6cd75eedaec93357732db859ba738f59d5" => :el_capitan
    sha256 "d6374fba65d24f7067197c9a7732f6f629dcb537f0687ab91f4f15d5c55d6cc6" => :yosemite
    sha256 "66cc127c640855b029881b2cd029197b093d92b8d77c3bb9a61167cbaedfedd8" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
