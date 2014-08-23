require 'formula'

class Gwt < Formula
  homepage 'https://developers.google.com/web-toolkit/'
  url 'https://storage.googleapis.com/gwt-releases/gwt-2.6.1.zip'
  sha1 '8ebc808e9ca6ef7e8f6460c8c0840423c192b3c5'

  def install
    rm Dir['*.cmd'] # remove Windows cmd files
    share.install Dir['*']

    # Don't use the GWT scripts because they expect the GWT jars to
    # be in the same place as the script.
    (bin/'webAppCreator').write <<-EOS.undent
      #!/bin/sh
      HOMEDIR=#{share}
      java -cp "$HOMEDIR/gwt-user.jar:$HOMEDIR/gwt-dev.jar" com.google.gwt.user.tools.WebAppCreator "$@";
    EOS

    (bin/'benchmarkViewer').write <<-EOS.undent
      #!/bin/sh
      APPDIR=#{share}
      java -Dcom.google.gwt.junit.reportPath="$1" -cp "$APPDIR/gwt-dev.jar" com.google.gwt.dev.RunWebApp -port auto $APPDIR/gwt-benchmark-viewer.war;
    EOS

    (bin/'i18nCreator').write <<-EOS.undent
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
