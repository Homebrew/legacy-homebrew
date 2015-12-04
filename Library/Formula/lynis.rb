class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.1.1.tar.gz"
  sha256 "d17b3cbbd305c52b9cd0d5141f41954882f398db44f26c10cb45fdaaa46a99d2"

  bottle do
    cellar :any
    sha256 "93bbd36e428e726b5471e6263b81238718dd768fc746f3218f71c11775c1e9d6" => :yosemite
    sha256 "79a494362cd5726d34da7dfe36b7028e294ded054c10c18ff6dd81b1a1bbf86d" => :mavericks
    sha256 "c45fd90de1946c059a807ec0cdb59c704186335a836b14f1075b80a7ef26203d" => :mountain_lion
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
