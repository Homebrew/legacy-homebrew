require "formula"

class Geogit < Formula
  homepage "http://geogig.org/"
  url "https://downloads.sourceforge.net/project/geogig/geogig-1.0-beta1/geogig-cli-app-1.0-beta1.zip"
  sha1 "4d7b2594bed7f9c9a6816d69f6a9d68c85ed0605"

  def install
    bin.install "bin/geogig", "bin/geogig-console", "bin/geogig-gateway"
    bin.env_script_all_files(libexec, :JAVA_HOME => "$(/usr/libexec/java_home)")
    prefix.install "repo"
  end

  def caveats; <<-EOS.undent
    GeoGit project was renamed to GeoGig. All bin tools start with 'geogig'.

    For all wrapper scripts in #{bin},
    $JAVA_HOME is set to be the output of:
      `/usr/libexec/java_home`
  EOS
  end

  test do
    system "#{bin}/geogig", "--version"
  end
end
