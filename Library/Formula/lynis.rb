require 'formula'

class Lynis < Formula
  homepage 'http://www.rootkit.nl/projects/lynis.html'
  url 'http://cisofy.com/files/lynis-1.5.6.tar.gz'
  sha1 '95aff8b208e8a1e97ef6d07d011e800cfa989f25'

  def install
    inreplace 'lynis' do |s|
      s.gsub!'tINCLUDE_TARGETS="/usr/local/include/lynis /usr/local/lynis/include /usr/share/lynis/include ./include"',
        %{tINCLUDE_TARGETS="#{include}"}
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins /usr/local/share/lynis/plugins /usr/share/lynis/plugins /etc/lynis/plugins ./plugins"',
        %{tPLUGIN_TARGETS="#{prefix}/plugins"}
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db /usr/share/lynis/db ./db"',
        %{tDB_TARGETS="#{prefix}/db"}
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis/default.prf /etc/lynis/default.prf ./default.prf"',
        %{tPROFILE_TARGETS="#{prefix}/default.prf"}
    end

    prefix.install "db", "dev", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end
end
