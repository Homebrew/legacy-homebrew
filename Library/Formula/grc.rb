class Grc < Formula
  desc "Colorize logfiles and command output"
  homepage "http://korpus.juls.savba.sk/~garabik/software/grc.html"
  url "http://korpus.juls.savba.sk/~garabik/software/grc/grc_1.9.orig.tar.gz"
  sha256 "41626e571ca255e1a9fe0816f3c0dfd1a30d9564d0decaf4b7365e28e3c54f5b"

  head "https://github.com/garabik/grc.git"

  bottle :unneeded

  conflicts_with "cc65", :because => "both install `grc` binaries"

  def install
    inreplace ["grc", "grc.1"], "/etc", etc
    inreplace ["grcat", "grcat.1"], "/usr/local", prefix

    etc.install "grc.conf"
    bin.install %w[grc grcat]
    (share+"grc").install Dir["conf.*"]
    man1.install %w[grc.1 grcat.1]

    etc.install "grc.bashrc"
    etc.install "grc.zsh" if build.head?
  end

  def caveats; <<-EOS.undent
    New shell sessions will start using GRC after you add this to your profile:
      source "`brew --prefix`/etc/grc.bashrc"
    EOS
  end

  test do
    require "open3"

    # Test the 'ls' config
    Open3.popen3("grcat", (share+"grc/conf.ls")) do |stdin, stdout, _|
      stdin.write("root")
      stdin.close
      assert_equal "\e[0m\e[1m\e[31mroot\e[0m\n", stdout.read
    end
  end
end
