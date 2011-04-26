require 'formula'
def no_emacs?
  ARGV.include? '--without-emacs'
end

class Notmuch < Formula
  homepage 'http://notmuchmail.org/'
  url 'http://notmuchmail.org/releases/notmuch-0.5.tar.gz'
  head 'git://notmuchmail.org/git/notmuch'

  # notmuch is such a moving target right now that it is not worth installing
  # from a 'release'.  Use the git version.

  depends_on 'talloc'
  depends_on 'gmime'
  depends_on 'xapian'
  depends_on 'emacs' unless no_emacs?

  unless ARGV.build_head?
    md5 '983cd907a7bf5ee0d12ebfb54cff784f' 
  end

  def options
    [
      ['--without-emacs', 'Compile without Emacs.  Only for use with --HEAD.']
    ]
  end

  def caveats; <<-EOS.undent
    Notmuch is such a moving target that it makes sense to install from HEAD
    only.  If you install the stable branch, emacs is a dependency.  The OS X
    version is lacking some support files.

    If you choose to install from HEAD (recommended), you can use the
    '--without-emacs' option to build just the library and command line
    application.  This is useful if you are planning to use notmuch with
    mutt.  However, if you are planning on using notmuch in it's emacs form,
    installing emacs is recommended.
      brew install --HEAD notmuch
      brew install --HEAD notmuch --without-emacs
    EOS
  end
  
  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"
    ]
    args.concat ['--without-emacs'] if no_emacs? and ARGV.build_head?

    system "./configure", *args

    # the current Makefile links to libnotmuch using a relative path.  This
    # needs to be specified with the final location.
    inreplace 'lib/Makefile.local', '-install_name $(SONAME)', '-install_name $(libdir)/$(SONAME)'

    system "make"
    system "make install"
    #system "install_name_tool -change libnotmuch.1.dylib /usr/local/lib/libnotmuch.1.dylib /usr/local/bin/notmuch"
  end
end
