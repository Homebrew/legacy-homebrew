require 'formula'

class ModWsgi <Formula
  @url='http://modwsgi.googlecode.com/files/mod_wsgi-2.5.tar.gz'
  @sha1='a2ed3fd60b390c3a790aca1c859093ab7a7c2d9d'
  @homepage='http://code.google.com/p/modwsgi/'

  def caveats
    " * You must manually edit /etc/apache2/httpd.conf to load mod_wsgi.so\n"+
    " * On 10.5, you must run Apache in 32-bit mode:\n"+
    "   http://code.google.com/p/modwsgi/wiki/InstallationOnMacOSX"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    archs = archs_for_command("python").collect{ |arch| "-arch #{arch}" }
    
    inreplace 'Makefile' do |s|
      s.gsub! "-Wc,'-arch ppc7400' -Wc,'-arch ppc64' -Wc,'-arch i386' -Wc,'-arch x86_64'",
              archs.collect{ |a| "-Wc,'#{a}'" }.join(' ')
      s.gsub! "-arch ppc7400 -arch ppc64 -arch i386 -arch x86_64",
              archs*' '
      # --libexecdir parameter to ./configure isn't changing this, so cram it in
      s.change_make_var! "LIBEXECDIR", libexec
    end

    system "make install"
  end
end
