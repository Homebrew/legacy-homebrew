require 'formula'

class Jwhois < Formula
  url 'http://ftpmirror.gnu.org/jwhois/jwhois-4.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/jwhois/jwhois-4.0.tar.gz'
  homepage 'http://directory.fsf.org/project/jwhois/'
  md5 '977d0ba90ee058a7998c94d933fc9546'

  # Patches provided by RedHat/RHEL
  # for more information see https://github.com/rmoriz/jwhois4-patches
  #
  def patches
    { :p1 => [
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-connect.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-ipv6match.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-conf.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-gi.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-enum.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-fclose.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-conf_update.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-conf_update2.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-dotster.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-conf_update3.patch',
          'https://raw.github.com/rmoriz/jwhois4-patches/jwhois-4.0-18.el6/contents/jwhois-4.0-conf_update4.patch'
       ]
    }
  end

  def install
    # link fails on libiconv if not added here
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "LIBS=-liconv"
    system "make install"
  end
end
