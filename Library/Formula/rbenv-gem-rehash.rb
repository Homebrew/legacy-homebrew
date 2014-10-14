require 'formula'

class RbenvGemRehash < Formula
  homepage 'https://github.com/sstephenson/rbenv-gem-rehash'
  url 'https://github.com/sstephenson/rbenv-gem-rehash/archive/v1.0.0.tar.gz'
  sha1 '40962ef5cda77ff46c0d0a3f262076b58088dd57'

  depends_on 'rbenv'

  # Fixes issues with Homebrew-managed git-etc alpha.
  patch do
    url "https://github.com/sstephenson/rbenv-gem-rehash/commit/0756890cfd9c7bbbdde38560fe81626a0c5769bd.diff"
    sha1 "17877b728eda6eaddc199bcd5935fcea757a1c63"
  end

  def install
    prefix.install Dir['*']
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
end
