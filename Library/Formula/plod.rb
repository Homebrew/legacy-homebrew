require 'formula'

class Plod <Formula
  url 'http://www.deer-run.com/~hal/plod/plod.shar'
  homepage 'http://www.deer-run.com/~hal/'
  md5 '2f1b52298eed7b660eb4a73c3a2cba83'
  version '1.9'

  def options
    [
      [ "--cryptcmd=<cmd>", "Supply a crypt command, if you wish." ],
      [ "--pager=<cmd>",
        "Pager, default is #{ENV['PAGER'] || '/usr/bin/less'}" ],
      [ "--editor=<cmd>",
        "Editor, default is #{ENV['EDITOR'] || '/usr/bin/emacs'}"],
      [ "--visual=<cmd>",
        "Visual editor, default is " +
        "#{ENV['VISUAL'] || ENV['EDITOR'] || '/usr/bin/emacs'}"]
    ]
  end

  def parse_plod_vars!
    @plod_vars = { :pager => ENV['PAGER'] || "/usr/bin/less",
                   :editor => ENV['EDITOR'] || "/usr/bin/emacs" }
    ARGV.each do |a|
      a.scan(/--([a-z]+)=(.+)$/) { |k, v| @plod_vars[k.to_sym] = v }
    end
    @plod_vars[:visual] = @plod_vars[:visual] || ENV['VISUAL'] ||
      @plod_vars[:editor]
  end

  def install
    system "sh plod.shar"
    parse_plod_vars!
    inreplace "plod" do |s|
      s.gsub! "#!/usr/local/bin/perl", "#!/usr/bin/env perl"
      s.gsub! '"/bin/crypt"',
        @plod_vars[:cryptcmd] ? "\"#{@plod_vars[:cryptcmd]}\"" : "undef"
      s.gsub! "/usr/local/bin/less", @plod_vars[:pager]
      s.gsub! '$EDITOR = "/usr/local/bin/emacs"',
        "$EDITOR = \"#{@plod_vars[:editor]}\""
      s.gsub! '$VISUAL = "/usr/local/bin/emacs"',
        "$VISUAL = \"#{@plod_vars[:visual]}\""
    end
    man1.install "plod.man" => "plod.1"
    bin.install "plod"
    prefix.install ['plod.el.v1', 'plod.el.v2']
  end

  def caveats; <<-EOS
Emacs users may want to peruse the two available plod modes. They've been
installed at:

  #{prefix}/plod.el.v1
  #{prefix}/plod.el.v2
EOS
  end
end
