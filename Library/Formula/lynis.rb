class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.1.1.tar.gz"
  sha256 "d17b3cbbd305c52b9cd0d5141f41954882f398db44f26c10cb45fdaaa46a99d2"

  bottle do
    cellar :any
    sha256 "ffe1367ab34281bad4881f5e9e241ce7588b8e1c3bf91d30c9b7046ce3719840" => :yosemite
    sha256 "b69c72aa39d5df2f29e8b71ce9c2e046737acc0198d0c713e4ff682684a72f7c" => :mavericks
    sha256 "4640574990172e652c31299a3982fdbd3db1db79eeb03f0e1706471b093e3bde" => :mountain_lion
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis /usr/local/lynis/include /usr/share/lynis/include ./include"',
        %(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins /usr/local/share/lynis/plugins /usr/share/lynis/plugins /etc/lynis/plugins ./plugins"',
        %(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db /usr/share/lynis/db ./db"',
        %(tDB_TARGETS="#{prefix}/db")
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis/default.prf /etc/lynis/default.prf /usr/local/lynis/default.prf ./default.prf"',
        %(tPROFILE_TARGETS="#{prefix}/default.prf")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end
end
