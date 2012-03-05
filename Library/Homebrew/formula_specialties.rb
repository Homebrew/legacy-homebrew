# Base classes for specialized types of formulae.

# See youtube-dl.rb for an example
class ScriptFileFormula < Formula
  def install
    bin.install Dir['*']
  end
end

# See flac.rb for an example
class GithubGistFormula < ScriptFileFormula
  def initialize name='__UNKNOWN__', path=nil
    super name, path
    @version=File.basename(File.dirname(url))[0,6]
  end
end
