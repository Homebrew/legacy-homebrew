require 'formula'

class Prettyping < ScriptFileFormula
  homepage 'http://denilsonsa.github.io/prettyping/'
  url 'https://raw.githubusercontent.com/denilsonsa/prettyping/v1.0.0/prettyping'
  sha1 '5e0296f9f28834d0985bb9f3452e777b35291350'
  version '1.0.0'
  def install
    bin.install 'prettyping'
  end
end
