require 'formula'

class YoutubeViewer < Formula
  homepage 'https://code.google.com/p/trizen'
  url 'https://github.com/trizen/youtube-viewer/archive/3.0.9.tar.gz'
  sha1 'a976246fade73b72f2f43aea782fbc6802eaa4d3'

  depends_on 'Data::Dump' => :perl
  depends_on 'LWP::UserAgent' => :perl
  depends_on 'Term::ANSIColor' => :perl
  depends_on 'Term::UI' => :perl
  depends_on 'URI::Escape' => :perl

  def install
    system "perl", "Build.PL"
    system "./Build"
    system "sudo ./Build install"
  end
end
