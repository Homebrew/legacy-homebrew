require 'formula'

class Mailtomutt <Formula
  url 'http://downloads.sourceforge.net/project/mailtomutt/MailtoMutt/v0.4.1/mailtomutt-0.4.1.tar.bz2'
  homepage 'http://mailtomutt.sourceforge.net'
  md5 'ce108e8574df129425d8156ff8b830bf'

  def install
    system "xcodebuild"
    prefix.install "build/Default/MailtoMutt.app"
  end

  def caveats; <<-EOS.undent
    MaitoMutt.app was installed in:
      #{prefix}

    To symlink into ~/Applications:
      brew linkapps
    EOS
  end
end
