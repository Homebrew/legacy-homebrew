require 'formula'

class ModWsgi < Formula
  homepage 'http://code.google.com/p/modwsgi/'
  url 'http://modwsgi.googlecode.com/files/mod_wsgi-3.3.tar.gz'
  sha1 'f32d38e5d3ed5de1efd5abefb52678f833dc9166'

  head 'http://modwsgi.googlecode.com/svn/trunk/mod_wsgi'

  def install
    # Remove a flag added when homebrew isn't in /usr/local
    # causes apxs to fail with "unknown flags" error
    ENV.remove 'CPPFLAGS', "-isystem #{HOMEBREW_PREFIX}/include"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    # We need apxs to specify the right compiler to its libtool, but
    # doing so causes libtool to die unless this flag is also set
    ENV['LTFLAGS'] = '--tag=CC'

    inreplace 'Makefile' do |s|
      # APXS uses just "gcc" unless we specify CC this way
      s.gsub! '$(APXS)', "$(APXS) -S CC=#{ENV.cc}"
      # Remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
      cflags = s.get_make_var("CFLAGS")
      cflags.gsub! "-Wc,'-arch ppc7400'", ""
      cflags.gsub! "-Wc,'-arch ppc64'", ""
      cflags.gsub! "-Wc,'-arch x86_64'", "" if Hardware.is_32_bit?
      s.change_make_var! "CFLAGS", cflags

      # --libexecdir parameter to ./configure isn't changing this, so cram it in
      # This will be where the Apache module ends up, and we don't want to touch
      # the system libexec.
      s.change_make_var! "LIBEXECDIR", libexec
    end

    system "make install"
  end

  def caveats
    <<-EOS.undent
    You must manually edit /etc/apache2/httpd.conf to load
      #{libexec}/mod_wsgi.so

    On 10.5, you must run Apache in 32-bit mode:
      http://code.google.com/p/modwsgi/wiki/InstallationOnMacOSX
    EOS
  end
end
