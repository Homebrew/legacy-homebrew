require 'formula'

class Bcompiler < Formula
  homepage 'http://pecl.php.net/package/bcompiler'
  url 'http://pecl.php.net/get/bcompiler-1.0.2.tgz'
  md5 '99f76a5ef536d43180b41036a6a13e43'

  def install
    Dir.chdir "bcompiler-#{version}" do
      system "phpize"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
      prefix.install "modules/bcompiler.so"
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test bcompiler`. Remove this comment before submitting
    # your pull request!
    system "make test"
  end

  def caveats; <<-EOS.undent
    To complete the install, You must add the following line to php.ini:
      #{prefix}/bcompiler.so
    EOS
  end
end
