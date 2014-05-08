require "formula"

class Ruby19Dependency < Requirement
  fatal true

  satisfy do
    `ruby --version` =~ /ruby (\d\.\d).\d/
    $1.to_f >= 1.9
  end

  def message
    "Selecta requires Ruby 1.9 or better."
  end
end

class Betty < Formula
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/fed0e108d9a9ceb059428a3601c163d939c80bbc.zip"
  sha1 "478b5a41563a0a6fe7e006c9c79f8d156d14e04b"
  version "0.1.3"

  depends_on Ruby19Dependency

  def install
    libexec.install 'lib', 'main.rb'
    (libexec/'betty').write <<-EOS.undent
      #!/usr/bin/env bash
      #{libexec/'main.rb'} $@
    EOS
    (libexec/'betty').chmod 0755
    bin.write_exec_script libexec/'betty'
  end

  test do
    system bin/'betty', 'speech on'
    system bin/'betty', 'what is your name'
    system bin/'betty', 'version'
    system bin/'betty', 'speech off'
  end
end
