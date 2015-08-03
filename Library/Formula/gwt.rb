class Gwt < Formula
  desc "Google web toolkit"
  homepage "http://www.gwtproject.org/"
  url "https://storage.googleapis.com/gwt-releases/gwt-2.7.0.zip"
  sha256 "aa65061b73836190410720bea422eb8e787680d7bc0c2b244ae6c9a0d24747b3"

  def install
    rm Dir["*.cmd"] # remove Windows cmd files
    share.install Dir["*"]

    # Don't use the GWT scripts because they expect the GWT jars to
    # be in the same place as the script.
    (bin/"webAppCreator").write <<-EOS.undent
      #!/bin/sh
      HOMEDIR=#{share}
      java -cp "$HOMEDIR/gwt-user.jar:$HOMEDIR/gwt-dev.jar" com.google.gwt.user.tools.WebAppCreator "$@";
    EOS

    (bin/"benchmarkViewer").write <<-EOS.undent
      #!/bin/sh
      APPDIR=#{share}
      java -Dcom.google.gwt.junit.reportPath="$1" -cp "$APPDIR/gwt-dev.jar" com.google.gwt.dev.RunWebApp -port auto $APPDIR/gwt-benchmark-viewer.war;
    EOS

    (bin/"i18nCreator").write <<-EOS.undent
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
