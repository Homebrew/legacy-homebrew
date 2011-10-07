require 'formula'

class Newlisp < Formula
  url 'http://www.newlisp.org/downloads/newlisp-10.3.2.tgz'
  homepage 'http://www.newlisp.org/'
  md5 '91aede51dc31fc1997d6c52adac3568a'

  depends_on 'readline'

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # Many .lsp files assume the interpreter will be installed in /usr/bin
    Dir.glob("**/*.lsp") do |f|
      inreplace f do |s|
        s.gsub! "!#/usr/bin/newlisp", "!#/usr/bin/env newlisp"
        s.gsub! "/usr/bin/newlisp", "#{bin}/newlisp"
      end
    end

    system "make check"
    system "make install"
  end

  # Use the IDE to test a complete installation
  def test
    system "newlisp-edit"
  end
end
