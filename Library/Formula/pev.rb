require 'formula'

class Pev < Formula
  homepage 'http://pev.sf.net/'
  url 'https://downloads.sourceforge.net/project/pev/pev-0.70/pev-0.70.tar.gz'
  sha1 'b2d1191c3b57049c78ef77b8f54f7f78838af129'

  head 'https://github.com/merces/pev.git'

  depends_on 'pcre'

  def install
    inreplace 'src/Makefile' do |s|
      s.gsub! '/usr', prefix
      s.change_make_var! "SHAREDIR", share
      s.change_make_var! "MANDIR", man
    end

    inreplace 'lib/libpe/Makefile' do |s|
      s.gsub! '/usr', prefix
    end

    system "make", "CC=#{ENV.cc}"
    system "make install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
