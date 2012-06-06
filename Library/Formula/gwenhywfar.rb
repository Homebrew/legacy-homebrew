require 'formula'

class Gwenhywfar < Formula
  homepage 'http://www.aqbanking.de/'
  url 'http://www.aquamaniac.de/sites/download/download.php?package=01&release=67&file=01&dummy=gwenhywfar-4.3.3.tar.gz'
  sha1 'c2ba4c45f1eeb379db6c2ae09122c592893f3bd0'

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
