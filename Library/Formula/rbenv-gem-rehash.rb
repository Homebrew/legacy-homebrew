class RbenvGemRehash < Formula
  desc "Automatically runs `rbenv rehash`"
  homepage "https://github.com/sstephenson/rbenv-gem-rehash"
  url "https://github.com/sstephenson/rbenv-gem-rehash/archive/v1.0.0.tar.gz"
  sha256 "93bdefa3e1376f0bea5a9ab7d24a26ae7d7f15ae3cd55cd0b6b03548ada7eed3"

  bottle :unneeded

  depends_on "rbenv"

  # Fixes issues with Homebrew-managed git-etc alpha.
  patch do
    url "https://github.com/sstephenson/rbenv-gem-rehash/commit/0756890cfd9c7bbbdde38560fe81626a0c5769bd.diff"
    sha256 "2fb4aba3e485fb01b0e51c510effb04dbddbf9ce3f29b41a20d4647d30b64cfa"
  end

  def install
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    If the GEM_PATH environment variable is undefined, rbenv-gem-rehash must
    first execute the gem env gempath command to retrieve RubyGems' default path
    so that it can can append to the path rather than override it. This can take
    a while--from a few hundred milliseconds on MRI to several seconds on
    JRuby--so the default path for the current Ruby version is cached to the
    filesystem the first time it is retrieved.
    EOS
  end

  test do
    assert_match "gem-rehash.bash", shell_output("rbenv hooks exec")
  end
end
