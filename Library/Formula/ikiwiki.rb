require 'formula'

class Ikiwiki < Formula
  url 'http://ftp.de.debian.org/debian/pool/main/i/ikiwiki/ikiwiki_3.20110328.tar.gz'
  homepage 'http://ikiwiki.info/'
  head 'git://git.ikiwiki.info/'

  depends_on 'Text::Markdown' => :perl
  depends_on 'URI' => :perl
  depends_on 'HTML::Parser' => :perl
  depends_on 'HTML::Scrubber' => :perl

  unless ARGV.build_head?
    md5 '4ab9f64367c13957b1db19ed8240d6a9'
  end

  def caveats; <<-EOS.undent
    ikiwiki is best installed from HEAD using git.  The configuration file for
    the wiki has the version encoded into the path.  If you choose to use the
    HEAD version and update ikiwiki, you will not have to update your wiki
    config files.
      brew install --HEAD ikiwiki

    System wide setup files are installed in /etc/ikiwiki.  If you choose to
    not install as root, either download the auto.setup file from
    <http://git.ikiwiki.info/?p=ikiwiki;a=tree> or setup the wiki by hand
    using these instructions <http://ikiwiki.info/setup/byhand/>.
    EOS
  end
  
  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end
