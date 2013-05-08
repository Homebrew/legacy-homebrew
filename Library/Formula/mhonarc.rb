require 'formula'

class Mhonarc < Formula
  homepage 'http://mhonarc.org/'
  url 'http://mhonarc.org/release/MHonArc/tar/MHonArc-2.6.18.tar.gz'
  sha1 'c5fbb3609c4004563662c20152d5b90317fc52cf'

  depends_on 'File::Basename' => :perl
  depends_on 'Fcntl' => :perl
  depends_on 'Getopt::Long' => :perl
  depends_on 'Symbol' => :perl
  depends_on 'Time::Local' => :perl

  env :userpaths # For perl, ruby

  def install
    which_perl = which 'perl'

    system "./install.me", "-perl", which_perl.to_s, "-manpath", "#{man}/",
                           "-prefix", "#{prefix}/", "-binpath", "#{bin}/", "-batch"
  end

  test do
    system "#{bin}/mhonarc", "-help"
  end
end
