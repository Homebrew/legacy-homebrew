require 'formula'

class Rc < Formula
  url 'http://rc-shell.slackmatic.org/release/rc-1.7.1.tar.gz'
  homepage 'http://rc-shell.slackmatic.org/'
  md5 '7253e1c853824cf27edb2166214f0511'

  depends_on 'readline' => :optional
  
  def options
    [
      ["--readline", "Add readline support."],
      ["--universal", "Build for both 32 & 64 bit Intel."],
    ]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}",
            "--prefix=#{prefix}", "--with-history"]

    ENV.universal_binary if ARGV.build_universal?
    
    if ARGV.include? '--readline'
      args << "--with-readline"
      args << "--with-readline-dir=#{Formula.factory('readline').prefix}"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end
