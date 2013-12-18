require 'formula'

class Pev < Formula
  homepage 'http://pev.sf.net/'
  url 'http://downloads.sourceforge.net/project/pev/pev-0.60/pev-0.60.tar.gz'
  sha1 '8d5e0bafb6dd4da0dcda6837928ad4babb6c8a94'

  head 'https://github.com/merces/pev.git'

  depends_on 'pcre'

  def install
    inreplace 'src/Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "SHAREDIR", share
      s.change_make_var! "MANDIR", man
    end

    inreplace 'lib/libpe/Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
    end

    system "make", "CC=#{ENV.cc}"
    system "make install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
