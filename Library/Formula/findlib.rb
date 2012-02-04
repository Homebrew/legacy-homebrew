require 'formula'

class Findlib <Formula
  url 'http://download.camlcity.org/download/findlib-1.2.6.tar.gz'
  homepage 'http://projects.camlcity.org/projects/findlib.html'
  md5 '4924c8c3ef1208eb0fa9096c8b8bb72f'

  depends_on 'objective-caml'
  skip_clean :all

  def install
    ENV.deparallelize
    inreplace "findlib.conf.in" do |s|
      # Fix '@SITELIB' 
      s.gsub! "@SITELIB@", "#{HOMEBREW_PREFIX}/lib/ocaml/site-lib"
    end
    system "./configure", "-bindir", bin, "-mandir", man, "-sitelib", "#{prefix}/lib/ocaml/site-lib", "-config", "#{prefix}/etc/findlib.conf"
    system "make"
    system "make install"
  end
end
