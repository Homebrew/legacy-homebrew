class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.2.0.tar.gz"
  sha256 "64fe15be52fa77bce14250867da87e8c262fb0e9229517c4e2d2d5a38223bea4"

  bottle do
    cellar :any_skip_relocation
    sha256 "843e6038c9637cc3f39a52d1c7475c0a751d0c7f4699b810fe09f63c79eaba43" => :el_capitan
    sha256 "704a1577a690667e11b78de4181c6308e736ef1dd1439f54d8c9ea7bce27d39f" => :yosemite
    sha256 "6b0b745d65629fcfd969f7c476b0ccb98255344aa303edca93a8e2a42029aeed" => :mavericks
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
