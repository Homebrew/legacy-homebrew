require 'formula'

class Ezlupdate < Formula
  # ezlupdate is part of eZ Publish
  url 'https://github.com/downloads/ezsystems/ezpublish/ezpublish_community_project-2011.10-with_ezc.tar.bz2'
  version '2011.10'
  homepage 'http://ezpedia.org/ez/ezlupdate'
  md5 'd40cbcf714c1071ffb6ee2c1e4975282'

  depends_on 'qt'

  def install
    Dir.chdir "support/ezlupdate-qt4.5/ezlupdate"
    # Use the qmake installation done with brew
    # because others installations can make a mess
    system "#{HOMEBREW_PREFIX}/bin/qmake ezlupdate.pro"
    system "make"
    Dir.chdir "../../.."
    bin.install ['bin/macosx/ezlupdate']
  end
end
