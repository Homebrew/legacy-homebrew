require 'formula'

class Mailtomutt <Formula
  url 'http://downloads.sourceforge.net/project/mailtomutt/MailtoMutt/v0.4.1/mailtomutt-0.4.1.tar.bz2'
  homepage 'http://mailtomutt.sourceforge.net'
  md5 'ce108e8574df129425d8156ff8b830bf'

  def install
    system "xcodebuild"
    prefix.install "build/Default/MailtoMutt.app"
  end

  def caveats
    <<-EOS
      MaitoMutt.app was installed in:
        #{prefix}

      If you have external command enabled, you can do:
        brew linkapps
      to symlink into ~/Applications
    EOS
  end
end
