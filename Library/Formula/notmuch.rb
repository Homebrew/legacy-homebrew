require 'formula'

class Notmuch <Formula
  url 'http://notmuchmail.org/releases/notmuch-0.5.tar.gz'
  homepage 'http://notmuchmail.org/'
  md5 '983cd907a7bf5ee0d12ebfb54cff784f'

  depends_on 'talloc'
  depends_on 'gmime'
  depends_on 'xapian'
  depends_on 'emacs'

  def install
    # OS X-shipped Emacs is too old (lacks json.el)
    emacs_prefix = Formula.factory('emacs').prefix
    inreplace 'configure', 'EMACS = emacs --quick', "EMACS = #{emacs_prefix}/Emacs.app/Contents/MacOS/Emacs --quick"

    system "./configure", "--prefix=#{prefix}"

    system "make all"

    system "make install"
  end
end
