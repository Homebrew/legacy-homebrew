require 'formula'

class Ezlupdate < Formula
  homepage 'http://ezpedia.org/ez/ezlupdate'
  url 'https://github.com/downloads/ezsystems/ezpublish/ezpublish_community_project-2011.10-with_ezc.tar.bz2'
  sha1 'd20912fda2438143d3981ca8e07bb52329e2cf25'

  depends_on 'qt'

  def install
    cd "support/ezlupdate-qt4.5/ezlupdate" do
      # Use the qmake installation done with brew
      # because others installations can make a mess
      system "#{HOMEBREW_PREFIX}/bin/qmake", "ezlupdate.pro"
      system "make"
    end
    bin.install 'bin/macosx/ezlupdate'
  end
end
