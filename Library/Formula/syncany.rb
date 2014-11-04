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
      rm Dir["*.bat"] # Windows batch scripts
      rm "syncany" # This is identical to the sy script, and the docs mostly refer to the sy script.
    end

    libexec.install Dir["build/install/syncany/*"]
    bin.install_symlink Dir["#{libexec}/bin/sy"]
  end

  def caveats; <<-EOS.undent
    Requires Java 1.7.0 or greater.

    The 'syncany' script is identical to the 'sy' script and as such has not
    been installed.

    You may want to add the following to your environment:

      alias syncany=sy

    For more details:
      http://syncany.readthedocs.org/en/latest/
    EOS
  end

  test do
    system "#{bin}/sy", "-vv"
  end
end
