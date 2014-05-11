require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb


class Osm2po < Formula
  homepage "osm2po.de/"
  url "http://osm2po.de/download.php?lnk=osm2po-4.8.8.zip"
  sha1 "878384eabbdfe4d9dfec6f354239db83ba7c25e1"

  def install
    libexec.install Dir["*"]
    ["gcl", "gclc"].each {|b| (bin/b).write_env_script libexec/b, "GACELA_PATH" => libexec, "CLASSPATH" => "$CLASSPATH:#{libexec}"}
  end
end
