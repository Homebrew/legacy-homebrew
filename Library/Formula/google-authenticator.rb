require 'formula'

class GoogleAuthenticator < Formula
  url 'http://google-authenticator.googlecode.com/files/libpam-google-authenticator-1.0-source.tar.bz2'
  sha1 '017b7d89989f1624e360abe02d6b27a6298d285d'
  head 'https://code.google.com/p/google-authenticator/', :using => :git
  homepage 'http://code.google.com/p/google-authenticator/'

  def install
    if ARGV.build_head?
      libpam_path = "libpam"
    else
      libpam_path = "."
    end
    system "cd #{libpam_path} && make"
    bin.install "#{libpam_path}/google-authenticator"
    (lib+"pam").install "#{libpam_path}/pam_google_authenticator.so"
  end

  def caveats; <<-EOS.undent
    google-authenticator PAM installed to:
      #{prefix}/lib/pam

    To actually plug this module into your system you must run:
        sudo ln -sf #{HOMEBREW_PREFIX}/lib/pam/pam_google_authenticator.so /usr/lib/pam/

    Then, add following line to desired PAM configurations under /etc/pam.d/:
        auth       required       pam_google_authenticator.so nullok

    For remote logins (e.g., ssh), /etc/pam.d/sshd is the file you would want to
    modify.  You can safely add it after all the "auth" lines.

    WARNING: After this point, each user should run google-authenticator command
    to generate their own secret for two-factor authentication.  Otherwise, they
    may not be able to login with their password alone.

    For other possible setups, read the long instruction:
      #{prefix}/README

    EOS
  end
end
