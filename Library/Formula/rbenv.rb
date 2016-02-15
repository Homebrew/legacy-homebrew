class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.0.0.tar.gz"
  sha256 "4658f2d8604ef847b39cb8216bb0d8a8aa000f504b6d06b30e008f92e6fa5210"
  head "https://github.com/rbenv/rbenv.git"

  bottle do
    cellar :any
    sha256 "02457958c3aae15e162436c481581639782134c7600c7cfd8eb9af1275f7b922" => :el_capitan
    sha256 "5f2bda33e2574d02eb076c70ef8de3e7765b40a8945c2fcc9749e9d9f9d7685c" => :yosemite
    sha256 "a8af7a2dfbf2aa9e1ce1dd0951550482e5456efb2b59ccc72c06b60d7186943b" => :mavericks
  end

  depends_on "ruby-build" => :recommended

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0"
      end
    end

    # Compile optional bash extension.
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `rbenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
                                           %(\\1"\\2-g#{git_revision}")
    end

    prefix.install ["bin", "completions", "libexec", "rbenv.d"]
  end

  def caveats; <<-EOS.undent
    Rbenv stores data under ~/.rbenv by default. If you absolutely need to
    store everything under Homebrew's prefix, include this in your profile:
      export RBENV_ROOT=#{var}/rbenv

    To enable shims and autocompletion, run this and follow the instructions:
      rbenv init
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end
