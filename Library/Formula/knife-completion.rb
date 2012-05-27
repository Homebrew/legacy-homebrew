require 'formula'

class KnifeCompletion < GithubGistFormula
  url 'https://raw.github.com/gist/1050685/b616645a4c9f56fb52d8fc65703e746f9e8ffd7c/knife'
  homepage 'https://gist.github.com/1050685'
  md5 '488e4ce424c37d2e4efcf7041fdacfd8'

  depends_on 'gnu-sed'

  def install
    (prefix+'etc/bash_completion.d').install Dir['*']
  end
end
