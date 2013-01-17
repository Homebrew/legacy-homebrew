require 'formula'

class DjangoCompletion < GithubGistFormula
  url 'https://gist.github.com/raw/4552835/e810c4075bbcdd4c4c0dd727901948fcf5f308b6/django_bash_completion'
  homepage 'https://gist.github.com/4552835'
  sha1 'd1aa4da325b24fd6cecbf3cd8e5e2d983932dd1f'

  def install
    (prefix+'etc/bash_completion.d').install Dir['*']
  end
end
