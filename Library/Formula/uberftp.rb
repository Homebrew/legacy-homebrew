require 'formula'

class Uberftp < Formula
  homepage 'http://dims.ncsa.illinois.edu/set/uberftp/'
  url 'https://github.com/JasonAlt/UberFTP/archive/Version_2_7.tar.gz'
  sha1 'f185e2ed567eca3484ca230e44a6ffdb4ec69792'

  depends_on 'globus-toolkit'

  def install
    # get the flavor
    globus = Formula["globus-toolkit"].opt_prefix

    core = `"#{globus}/sbin/gpt-query" globus_core`
    flavor = case core
      when /gcc64dbg/ then "gcc64dbg"
      when /gcc32dbg/ then "gcc32dbg"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-globus-flavor=#{flavor}",
                          "--with-globus=#{globus}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/uberftp", "-v"
  end
end
