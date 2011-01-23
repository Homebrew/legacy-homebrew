require 'formula'

class Lwt <Formula
  url 'http://ocsigen.org/download/lwt-2.2.0.tar.gz'
  homepage 'http://ocsigen.org/lwt'
  md5 '4e0b28cbc5a2dfe60013c91a5d051969'

  depends_on 'objective-caml'
  depends_on 'findlib'
  skip_clean :all

  def install
    system "./configure", "--prefix", HOMEBREW_PREFIX, "--mandir", man
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make"
    system "make install"
  end

end
