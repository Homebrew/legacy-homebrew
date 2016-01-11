class Plod < Formula
  desc "Keep an online journal of what you're working on"
  homepage "http://www.deer-run.com/~hal/"
  url "http://www.deer-run.com/~hal/plod/plod.shar"
  version "1.9"
  sha256 "1b7b8267c41b11c2f5413a8d6850099e0547b7506031b0c733121ed5e8d182f5"

  def install
    system "sh", "plod.shar"

    pager = ENV["PAGER"] || "/usr/bin/less"
    editor = ENV["EDITOR"] || "/usr/bin/emacs"
    visual = ENV["VISUAL"] || editor

    inreplace "plod" do |s|
      s.gsub! "#!/usr/local/bin/perl", "#!/usr/bin/env perl"
      s.gsub! '"/bin/crypt"', "undef"
      s.gsub! "/usr/local/bin/less", pager
      s.gsub! '$EDITOR = "/usr/local/bin/emacs"', "$EDITOR = \"#{editor}\""
      s.gsub! '$VISUAL = "/usr/local/bin/emacs"', "$VISUAL = \"#{visual}\""
    end
    man1.install "plod.man" => "plod.1"
    bin.install "plod"
    prefix.install "plod.el.v1", "plod.el.v2"

    (prefix/"plodrc").write <<-PLODRC.undent
      # Uncomment lines and change their values to override defaults.
      # man plod for further details.
      #
      # $PROMPT = 0;
      # $CRYPTCMD = undef;
      # $TMPFILE = "/tmp/plodtmp$$";
      # $HOME = (getpwuid($<))[7];
      # $EDITOR = "#{editor}";
      # $VISUAL = "#{visual}";
      # $PAGER =  "#{pager}";
      # $LINES = 24;
      # $LOGDIR = "$HOME/.logdir";
      # $LOGFILE = sprintf("%04d%02d", $YY+1900, $MM);
      # $BACKUP = ".plod$$.bak";
      # $DEADLOG = "dead.log";
      # $STAMP = sprintf("%02d/%02d/%04d, %02d:%02d --", $MM, $DD, $YY+1900, $hh, $mm);
      # $PREFIX = '';
      # $SUFFIX = '';
      # $SEPARATOR = '-----';
    PLODRC
  end

  def caveats; <<-EOS.undent
      Emacs users may want to peruse the two available plod modes. They've been
      installed at:

        #{prefix}/plod.el.v1
        #{prefix}/plod.el.v2

      Certain environment variables can be customized.

        cp #{prefix}/plodrc ~/.plodrc

      See man page for details.
    EOS
  end

  test do
    ENV["LOGDIR"] = testpath/".logdir"
    system "#{bin}/plod", "this", "is", "Homebrew"
    assert File.directory? "#{testpath}/.logdir"
    assert_match(/this is Homebrew/, shell_output("#{bin}/plod -P"))
  end
end
