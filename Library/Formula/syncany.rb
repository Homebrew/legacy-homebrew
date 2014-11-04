require "formula"

class Syncany < Formula
  homepage "https://www.syncany.org"
  url "https://codeload.github.com/syncany/syncany/tar.gz/v0.1.12-alpha"
  sha1 "72af093bb67b384eea73c63071abf4f1c030a810"
  version "0.1.12-alpha"
  head "https://github.com/syncany/syncany.git"

  depends_on :java => "1.7"

  def install
    system "./gradlew", "installApp"

    inreplace "build/install/syncany/bin/syncany" do |s|
      s.gsub! /APP_HOME="`pwd -P`"/, %{APP_HOME="#{libexec}"}
    end

    cd "build/install/syncany/bin" do
      rm "sy.bat"
      rm "syncany.bat"
      rm "sy" # This is identical to the syncany script
    end

    libexec.install Dir["build/install/syncany/*"]
    bin.install_symlink Dir["#{libexec}/bin/syncany"]
  end

  def caveats; <<-EOS.undent
    Requires Java 1.7.0 or greater.

    The 'sy' script is identical to the 'syncany' script and as such has not
    been installed.

    You may add the following to your shell config to accommodate the syncany
    documentation (which tends to refer to the 'sy' command):

      alias sy=syncany

    For more details:
      http://syncany.readthedocs.org/en/latest/
    EOS
  end
end
