require 'formula'

class Gnunet < Formula
  url 'ftp://ftp.gnu.org/gnu/gnunet/gnunet-0.9.0pre2.tar.gz'
  homepage 'https://gnunet.org/'
  md5 'a4d0fad4f6fc6b520b3b73ee54167270'
  version '0.9.0pre2'

  head 'https://gnunet.org/svn/gnunet', :using => :svn

  depends_on 'libextractor'
  depends_on 'curl'
  depends_on 'libmicrohttpd'
  depends_on 'libtool'
  depends_on 'sqlite'
  depends_on 'libgcrypt'

  def install
    ENV.deparallelize

    if ARGV.build_head?
      system "./bootstrap"
    end

    system "./configure",
    "--disable-debug",
    "--disable-dependency-tracking",
    "--prefix=#{prefix}",
    "--with-extractor=#{HOMEBREW_PREFIX}",
    "--with-libcurl=#{HOMEBREW_PREFIX}"

    system "make"
    system "make install"
  end


  def patches
    if not ARGV.build_head?
      ["https://gist.github.com/raw/958897/gnunet-service-dns.c.diff",
       "https://gist.github.com/raw/958897/gnunet-daemon-vpn.c.diff",
       "https://gist.github.com/raw/958897/plugin_transport_http.c.diff"]
    end
  end
end
