require 'brewkit'

class Tree <Formula
  @url='ftp://mama.indstate.edu/linux/tree/tree-1.5.2.2.tgz'
  @homepage='http://mama.indstate.edu/users/ice/tree/'
  @md5='a7731a898e2c0d7e422a57a84ffbb06c'

  def install
    system "#{ENV.cc} #{ENV['CFLAGS']} -o tree tree.c strverscmp.c"

    bin.install "tree"
    man1.install "man/tree.1"
  end
end
