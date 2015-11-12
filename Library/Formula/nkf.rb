class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://osdn.jp/projects/nkf/"
  url "http://dl.osdn.jp/nkf/59912/nkf-2.1.3.tar.gz"
  sha256 "8cb430ae69a1ad58b522eb4927b337b5b420bbaeb69df255919019dc64b72fc2"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8ff7763563ac384a0401d5719fd0948c1aaab1a92a1833e37f0fcf5328797f8a" => :el_capitan
    sha256 "4604f107d1afb7b60216961fae82771bfc79b82c35c1013468b185b96b2691c9" => :yosemite
    sha256 "be101e0c95328993f661b8d81a23b141cc3f8b863908cc9b7d650eab1b82daa6" => :mavericks
  end

  def install
    inreplace "Makefile", "$(prefix)/man", "$(prefix)/share/man"
    system "make", "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end
end
