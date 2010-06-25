require 'formula'

class Cherokee <Formula
  url 'http://www.cherokee-project.com/download/1.0/1.0.4/cherokee-1.0.4.tar.gz'
  homepage 'http://www.cherokee-project.com/'
  md5 '24874b465abe6611ef2f2c145a840cb2'

  depends_on 'gettext'

  skip_clean "var/run"
  skip_clean "var/log"
  skip_clean "var/lib/cherokee/graphs/images"

  def caveats
  <<-EOS.undent
    Cherokee is setup to run with your (#{ENV['USER']}) permissions as part of the www group
    on port 80. This can be changed in the cherokee-admin but be aware the new user will need
    permissions to write to #{var} for logging and runtime files.

    If this is your first install, automatically load on startup with:
        sudo cp #{prefix}/org.cherokee.webserver.plist /System/Library/LaunchDaemons
        sudo launchctl load -w /System/Library/LaunchDaemons/org.cherokee.webserver.plist

    If this is an upgrade and you already have the org.cherokee.webserver.plist loaded:
        sudo launchctl unload -w /System/Library/LaunchDaemons/org.cherokee.webserver.plist
        sudo cp #{prefix}/org.cherokee.webserver.plist /System/Library/LaunchDaemons
        sudo launchctl load -w /System/Library/LaunchDaemons/org.cherokee.webserver.plist
  EOS
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking",
           "--with-wwwuser=#{ENV['USER']}", "--with-wwwgroup=www"
    system "make install"

    prefix.install "org.cherokee.webserver.plist"
  end
end
