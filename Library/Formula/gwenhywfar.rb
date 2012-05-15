require 'formula'

class Gwenhywfar < Formula
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=01&release=66&file=01&dummy=gwenhywfar-4.3.2.tar.gz'
  homepage 'http://www.aqbanking.de/'
  md5 '6fcd39f64e6357321cffeaca470fbe52'
  head 'http://devel.aqbanking.de/svn/gwenhywfar/trunk'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gnutls'

  def options
    [[
      "--with-gui=XX,...", <<-EOS.undent
        Install gui support XX where XX is the name of the gui toolkit
        \te.g.: --with-gui=gtk
        \tAvailable gui toolkits are: qt, gtk"
        EOS
    ]]
  end


  def install
    guis = []
    ARGV.options_only.select { |v| v =~ /--with-gui=/ }.uniq.each do |opt|
      guis << opt.split('=')[1].split(',')
    end

    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-guis='#{guis.flatten.join(' ')}'"
    ]

    system "./configure", *configure_args
    system "make install"
  end
end
