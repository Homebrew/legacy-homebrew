require 'formula'

class Atf < Formula
  desc "ATF: Automated Testing Framework"
  homepage 'https://github.com/jmmv/atf'
  url 'https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz'
  sha1 '7cc9d3703f7c0e00bb8ec801f7ac65ac9dc898d7'

  bottle do
    sha1 "5688f4c5066575165a7b9daf9aee4cc21f639656" => :yosemite
    sha1 "6b3e5320b3cdc1b56556f1f41f819f684055c551" => :mavericks
    sha1 "b7b43370c8bcf25b46c77b298b05e0d53098f7ad" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system 'make'
    ENV.j1
    system 'make install'
  end
end
