require 'formula'

class Cherokee < Formula
  homepage 'http://www.cherokee-project.com/'
  url 'http://www.cherokee-project.com/download/1.2/1.2.101/cherokee-1.2.101.tar.gz'
  sha1 'b27f149c7d7111207ac8c3cd8a4856c05490d136'

  head 'https://github.com/cherokee/webserver.git'

  depends_on 'gettext'
  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    if build.head?
      ENV['LIBTOOL'] = 'glibtool'
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      cmd = './autogen.sh'
    else
      cmd = './configure'
    end

    system cmd, "--disable-dependency-tracking",
                "--prefix=#{prefix}",
                "--sysconfdir=#{etc}",
                "--localstatedir=#{var}/cherokee",
                "--with-wwwuser=#{ENV['USER']}",
                "--with-wwwgroup=www",
                "--enable-internal-pcre",
                # Don't install to /Library
                "--with-wwwroot=#{etc}/cherokee/htdocs",
                "--with-cgiroot=#{etc}/cherokee/cgi-bin"
    system "make install"

    prefix.install "org.cherokee.webserver.plist"
    (prefix+'org.cherokee.webserver.plist').chmod 0644
    (share+'cherokee/admin/server.py').chmod 0755
  end

  def caveats
    <<-EOS.undent
      Cherokee is setup to run with your user permissions as part of the
      www group on port 80. This can be changed in the cherokee-admin
      but be aware the new user will need permissions to write to:
        #{var}/cherokee
      for logging and runtime files.

      By default, documents will be served out of:
        #{etc}/cherokee/htdocs

      And CGI scripts from:
        #{etc}/cherokee/cgi-bin

       If this is your first install, automatically load on startup with:
          sudo cp #{prefix}/org.cherokee.webserver.plist /Library/LaunchDaemons
          sudo launchctl load -w /Library/LaunchDaemons/org.cherokee.webserver.plist

      If this is an upgrade and you already have the plist loaded:
          sudo launchctl unload -w /Library/LaunchDaemons/org.cherokee.webserver.plist
          sudo cp #{prefix}/org.cherokee.webserver.plist /Library/LaunchDaemons
          sudo launchctl load -w /Library/LaunchDaemons/org.cherokee.webserver.plist
    EOS
  end
end
