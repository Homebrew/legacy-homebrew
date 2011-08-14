require 'formula'

class Cmigemo <Formula
  url 'http://cmigemo.googlecode.com/files/cmigemo-default-src-20110227.zip'
  md5 '6e9b6f6ec96d4eb8bdd18e52b91e1b85'
  homepage 'http://www.kaoriya.net/software/cmigemo'

  depends_on 'nkf'

  def patches
    p = []
    p << "https://raw.github.com/gist/1145129/d6b4ad34f3763cac352dbc6d96cf6aa2566e4b7a/wordbuf.c.patch"
  end

  def install
    system "chmod 755 ./configure"
    system "./configure"
    system "make osx"
    system "make osx-dict"
    Dir.chdir('dict') do
      system "make utf-8"
    end
    system "make osx-install"
  end

  def caveats
    <<-EOS
    See also https://gist.github.com/457761 to use cmigemo via your Emacs.
    You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end
