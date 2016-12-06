require 'formula'

class Findlib < Formula
  url 'http://download.camlcity.org/download/findlib-1.2.7.tar.gz'
  homepage 'http://projects.camlcity.org/projects/findlib.html'
  md5 '000bff723e8d3d727a7edd5b5901b540'

  depends_on 'objective-caml'
  skip_clean :all

  def install
    ENV.deparallelize
    inreplace "findlib.conf.in" do |s|
      # Fix '@SITELIB'
      s.gsub! "@SITELIB@", "#{HOMEBREW_PREFIX}/lib/ocaml/site-lib"
    end
    system "./configure", "-bindir", bin, "-mandir", man, "-sitelib", "#{lib}/ocaml/site-lib", "-config", "#{prefix}/etc/findlib.conf"
    system "make all opt"
    system "make install"
  end
end
