require 'formula'

class AdolC < Formula
  homepage 'https://projects.coin-or.org/ADOL-C'
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.3.0.tgz'
  sha1 'd9124ce0b199cb8b841a9a9ec10d1fb31ed11b49'

  head 'https://projects.coin-or.org/svn/ADOL-C/trunk/', :using => :svn

  depends_on 'colpack'

  def install
    # Make our own realpath script
    (buildpath/'realpath').write <<-EOS.undent
      #!/usr/bin/python
      import os,sys
      print os.path.realpath(sys.argv[1])
    EOS
    system "chmod +x ./realpath"

    # Configure may get automatically regenerated.  So patch configure.ac also.
    inreplace %w(configure configure.ac) do |s|
      s.gsub! "readlink -f", "/#{buildpath}/realpath"
      s.gsub! "lib64", "lib"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-sparse",
                          "--with-colpack=#{HOMEBREW_PREFIX}"
    system "make install"
    system "make test"
  end
end
