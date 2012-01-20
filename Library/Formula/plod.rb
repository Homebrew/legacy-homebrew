require 'formula'

class Plod < Formula
  url 'http://www.deer-run.com/~hal/plod/plod.shar'
  homepage 'http://www.deer-run.com/~hal/'
  md5 '2f1b52298eed7b660eb4a73c3a2cba83'
  version '1.9'

  def install
    system "sh plod.shar"
    set_plod_vars!
    inreplace "plod" do |s|
      s.gsub! "#!/usr/local/bin/perl", "#!/usr/bin/env perl"
      s.gsub! '"/bin/crypt"', "undef"
      s.gsub! "/usr/local/bin/less", @plod_vars[:pager]
      s.gsub! '$EDITOR = "/usr/local/bin/emacs"',
        "$EDITOR = \"#{@plod_vars[:editor]}\""
      s.gsub! '$VISUAL = "/usr/local/bin/emacs"',
        "$VISUAL = \"#{@plod_vars[:visual]}\""
    end
    man1.install "plod.man" => "plod.1"
    bin.install "plod"
    prefix.install ['plod.el.v1', 'plod.el.v2']
    ohai "Creating #{prefix}/plodrc"
    (prefix + "plodrc").write plodrc
  end

  def set_plod_vars!
    @plod_vars = { :pager => ENV['PAGER'] || "/usr/bin/less",
                   :editor => ENV['EDITOR'] || "/usr/bin/emacs" }
    @plod_vars[:visual] = @plod_vars[:visual] || ENV['VISUAL'] ||
      @plod_vars[:editor]
  end

  def plodrc; <<-PLODRC
# Uncomment lines and change their values to override defaults.
# man plod for further details.
#
# $PROMPT = 0;
# $CRYPTCMD = undef;
# $TMPFILE = "/tmp/plodtmp$$";
# $HOME = (getpwuid($<))[7];
# $EDITOR = "#{@plod_vars[:editor]}";
# $VISUAL = "#{@plod_vars[:visual]}";
# $PAGER =  "#{@plod_vars[:pager]}";
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

  def caveats; <<-EOS
Emacs users may want to peruse the two available plod modes. They've been
installed at:

  #{prefix}/plod.el.v1
  #{prefix}/plod.el.v2

Certain environment variables can be customized.

  cp #{prefix}/plodrc ~/.plodrc

See man page for details.
EOS
  end
end
