require 'formula'

# Installs Google Web Toolkit.

class Gwt < Formula
  homepage 'https://developers.google.com/web-toolkit/'
  url 'http://google-web-toolkit.googlecode.com/files/gwt-2.5.0.rc2.zip'
  version '2.5.0-rc2'
  sha1 '9a9d0f16c9fda7ffebc04016aa3c735e1057b0e8'

  def install
    # The SDK zip contains everything pre-built.

    rm Dir['*.cmd'] # remove Windows cmd files
    share.install Dir['*']

    #Don't use the GWT scripts because they expect the GWT jars to
    # be in the same place as the script.
    (bin+'webAppCreator').write <<-EOS.undent
        #!/bin/sh
        HOMEDIR=#{share}
        java -cp "$HOMEDIR/gwt-user.jar:$HOMEDIR/gwt-dev.jar" com.google.gwt.user.tools.WebAppCreator "$@";
    EOS

    (bin+'benchmarkViewer').write <<-EOS.undent
        #!/bin/sh
        APPDIR=#{share}
        java -Dcom.google.gwt.junit.reportPath="$1" -cp "$APPDIR/gwt-dev.jar" com.google.gwt.dev.RunWebApp -port auto $APPDIR/gwt-benchmark-viewer.war;
    EOS

    (bin+'i18nCreator').write <<-EOS.undent
        #!/bin/sh
        HOMEDIR=#{share}
        java -cp "$HOMEDIR/gwt-user.jar:$HOMEDIR/gwt-dev.jar" com.google.gwt.i18n.tools.I18NCreator "$@";
    EOS

  end

  def caveats
    <<-EOS.undent
        The GWT jars are available at #{share}
    EOS
  end
end
