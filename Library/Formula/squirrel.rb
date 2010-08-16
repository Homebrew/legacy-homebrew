require 'formula'

class Squirrel <Formula
  url 'http://downloads.sourceforge.net/project/squirrel/squirrel2/squirrel%202.2.4%20stable/squirrel_2.2.4_stable.tar.gz'
  homepage 'http://www.squirrel-lang.org'
  md5 'e411dfd1bcc5220aa80de53e4a5f094d'

  def install
    system "make"

    prefix.install %w[bin include lib]
	
    doc.install Dir['doc/*.pdf']
    doc.install %w[etc samples]
  end
end
