require 'formula'

class StartupNotification < Formula
  url 'http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/startup-notification'
  md5 '2cd77326d4dcaed9a5a23a1232fb38e9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
