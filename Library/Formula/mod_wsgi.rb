require 'brewkit'

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
    FileUtils.mv 'LICENCE', 'LICENSE'
    system "./configure --prefix='#{prefix}' --disable-debug --disable-dependency-tracking"

    # The arch flags should match your Python's arch flags.
    archs = arch_for_command "`which python`"
    
    comp_flags = ''
    link_flags = ''
    archs.each do |a|
      comp_flags += " -Wc,'-arch #{a}'"
      link_flags += " -arch #{a}"
    end
    
    inreplace 'Makefile',
      "-Wc,'-arch ppc7400' -Wc,'-arch ppc64' -Wc,'-arch i386' -Wc,'-arch x86_64'",
      "#{comp_flags}"
 
    inreplace 'Makefile',
      "-arch ppc7400 -arch ppc64 -arch i386 -arch x86_64",
      "#{link_flags}"
    
    # --libexecdir parameter to ./configure isn't changing this, so cram it in
    inreplace 'Makefile', "LIBEXECDIR = /usr/libexec/apache2", "LIBEXECDIR = #{libexec}"

    system "make install"
  end
end
