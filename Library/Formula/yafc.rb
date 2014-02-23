require 'formula'

class Yafc < Formula
  homepage 'http://www.yafc-ftp.com/'
  url 'http://www.yafc-ftp.com/upload/yafc-1.3.1.tar.xz'
  sha1 '63f958446c9a88fed2413e95cc1e8058570f77df'

  depends_on 'xz' => :build
  depends_on 'readline'
  depends_on 'libssh' => :recommended

  def patches
    DATA
  end

  def install
    readline = Formula["readline"].opt_prefix

    readline = Formula.factory('readline').opt_prefix
    args = ["--prefix=#{prefix}",
            "--with-readline=#{readline}"]
    args << "--without-ssh" if build.without? "libssh"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/yafc", "-V"
  end
end

__END__
# The bash-completion script assumes GNU sed and its 'r' option for
# extended regular expressions. OSX's sed calls this 'E' (they're not
# entirely compatible, but enough for this use case).
diff --git a/completion/yafc b/completion/yafc
index d4f2189..4694d44 100644
--- a/completion/yafc
+++ b/completion/yafc
@@ -9,7 +9,7 @@ _yafc()
     cur=`_get_cword`
 
     if [ $COMP_CWORD -eq 1 ] && [ -f ~/.yafc/bookmarks ]; then
-        COMPREPLY=( $( compgen -W '$( sed -nre "/machine/ s/.* alias '\''([^'\'']*)'\''/\1/ p" \
+        COMPREPLY=( $( compgen -W '$( sed -nEe "/machine/ s/.* alias '\''([^'\'']*)'\''/\1/ p" \
             ~/.yafc/bookmarks )' -- "$cur" ) )
     fi
