require 'formula'

class ModWsgi <Formula
  url 'http://modwsgi.googlecode.com/files/mod_wsgi-3.3.tar.gz'
  sha1 'f32d38e5d3ed5de1efd5abefb52678f833dc9166'
  homepage 'http://code.google.com/p/modwsgi/'
  head "http://modwsgi.googlecode.com/svn/trunk/mod_wsgi"

  def caveats
    <<-EOS.undent
    NOTE: "brew install -v mod_wsgi" will fail! You must install
    in non-verbose mode for this to succeed. Patches to fix this
    are welcome.

    * You must manually edit /etc/apache2/httpd.conf to load
      #{libexec}/mod_wsgi.so

    * On 10.5, you must run Apache in 32-bit mode:
      http://code.google.com/p/modwsgi/wiki/InstallationOnMacOSX
    EOS
  end

  def install
    # Remove a flag added when homebrew isn't in /usr/local
    # causes apxs to fail with unknown flags s,y,s,t,m
    ENV.remove 'CPPFLAGS', "-isystem #{HOMEBREW_PREFIX}/include"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    # Find the archs of the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.delete :ppc7400
    archs.delete :ppc64

    inreplace 'Makefile' do |s|
      s.gsub! "-Wc,'-arch x86_64' -Wc,'-arch i386' -Wc,'-arch ppc7400'",
              archs.collect{ |a| "-Wc,'-arch #{a}'" }.join(' ')

      s.gsub! "-arch x86_64 -arch i386 -arch ppc7400",
              archs.collect{ |a| "-arch #{a}" }.join(' ')

      # --libexecdir parameter to ./configure isn't changing this, so cram it in
      # This will be where the Apache module ends up, and we don't want to touch
      # the system libexec.
      s.change_make_var! "LIBEXECDIR", libexec
    end

    system "make install"
  end
end
