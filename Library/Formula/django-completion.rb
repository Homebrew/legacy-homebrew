require 'formula'

class DjangoCompletion < GithubGistFormula
  url 'https://gist.github.com/raw/4552835/47a0d6983b08b66081695d6a8683be280b05a61f/django_bash_completion'
  homepage 'https://gist.github.com/4552835'
  sha1 'c1b0eab397bfd09bbb197298fd0a7808d983b750'

  def install
    (prefix+'etc/bash_completion.d').install Dir['*']
  end
end
