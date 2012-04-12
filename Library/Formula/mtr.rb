require 'formula'

class Mtr < Formula
  homepage 'http://www.bitwizard.nl/mtr/'
  url 'ftp://ftp.bitwizard.nl/mtr/mtr-0.82.tar.gz'
  sha1 'f1319de27324d85898a9df0a293a438bbaaa12b5'

  depends_on 'gtk+' unless ARGV.include? "--no-gtk"

  def options
    [['--no-gtk', "Don't build with Gtk+ support"]]
  end

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV['LIBS'] = "-lresolv"
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-gtk" if ARGV.include? "--no-gtk"
    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    mtr requires superuser privileges. You can either run the program
    via `sudo`, or change its ownership to root and set the setuid bit:

      sudo chown root:wheel #{sbin}/mtr
      sudo chmod u+s #{sbin}/mtr

    In any case, you should be certain that you trust the software you
    are executing with elevated privileges.
    EOS
  end
end
