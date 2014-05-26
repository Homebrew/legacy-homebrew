require 'formula'

class Tpp < Formula
  homepage 'http://synflood.at/tpp.html'
  url 'http://synflood.at/tpp/tpp-1.3.1.tar.gz'
  sha1 'e99fca1d7819c23d4562e3abdacea7ff82563754'

  depends_on 'figlet' => :optional

  resource 'ncurses-ruby' do
    url 'https://downloads.sf.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2'
    sha1 'e50018fc906e5048403b277a898117e782e267c4'
  end

  def install
    lib_ncurses = libexec+'ncurses-ruby'
    inreplace 'tpp.rb', 'require "ncurses"', <<-EOS.undent
      require File.expand_path('#{lib_ncurses}/ncurses_bin.bundle', __FILE__)
      require File.expand_path('#{lib_ncurses}/ncurses_sugar.rb', __FILE__)
    EOS

    bin.install 'tpp.rb' => 'tpp'
    share.install 'contrib', 'examples'
    man1.install 'doc/tpp.1'
    doc.install 'README', 'CHANGES', 'DESIGN', 'COPYING', 'THANKS', 'README.de'

    resource('ncurses-ruby').stage do
      inreplace 'extconf.rb', '$CFLAGS  += " -g"',
                              '$CFLAGS  += " -g -DNCURSES_OPAQUE=0"'
      system 'ruby', 'extconf.rb'
      system 'make'
      lib_ncurses.install 'lib/ncurses_sugar.rb', 'ncurses_bin.bundle'
    end
  end

  test do
    assert_equal "tpp - text presentation program #{version}",
                 `#{bin}/tpp --version`.chomp
  end
end
