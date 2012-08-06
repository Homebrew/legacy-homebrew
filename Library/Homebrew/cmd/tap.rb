module Homebrew extend self

  def tap
    if ARGV.empty?
      tapd = HOMEBREW_LIBRARY/"Taps"
      tapd.children.each do |tap|
        next unless (tap/'.git').directory?
        puts tap.basename.to_s =~ /^direct_/ ? tap.basename.sub(/^direct_/,'') : tap.basename.sub('-','/')
      end if tapd.directory?
    elsif ARGV.first == "--repair"
      repair_taps
    else
      install_tap(*tap_args)
    end
  end

  def install_tap clone_url, tapd_name
    raise "brew install git" unless which 'git'

    # we downcase to avoid case-insensitive filesystem issues
    tapd = HOMEBREW_LIBRARY/"Taps/#{tapd_name.downcase}"
    raise "Already tapped!" if tapd.directory?
    abort unless system "git clone #{clone_url} #{tapd}"

    files = []
    tapd.find_formula{ |file| files << tapd.basename.join(file) }
    tapped = link_tap_formula(files)
    puts "Tapped #{tapped} formula"
  end

  def link_tap_formula formulae
    ignores = (HOMEBREW_LIBRARY/"Formula/.gitignore").read.split rescue []
    tapped = 0

    cd HOMEBREW_LIBRARY/"Formula" do
      formulae.each do |formula|
        from = HOMEBREW_LIBRARY.join("Taps/#{formula}")
        to = HOMEBREW_LIBRARY.join("Formula/#{formula.basename}")

        # Unexpected, but possible, lets proceed as if nothing happened
        to.delete if to.symlink? and to.realpath == from

        # using the system ln is the only way to get relative symlinks
        system "ln -s ../Taps/#{formula} 2>/dev/null"
        if $?.success?
          ignores << formula.basename.to_s
          tapped += 1
        else
          to = to.realpath if to.exist?
          opoo "Could not tap #{Tty.white}#{from.tap_ref}#{Tty.reset} over #{Tty.white}#{to.tap_ref}#{Tty.reset}"
        end
      end
    end

    HOMEBREW_LIBRARY.join("Formula/.gitignore").atomic_write(ignores.uniq.join("\n"))

    tapped
  end

  def repair_taps
    count = 0
    # prune dead symlinks in Formula
    Dir["#{HOMEBREW_REPOSITORY}/Library/Formula/*.rb"].each do |fn|
      if not File.exist? fn
        File.delete fn
        count += 1
      end
    end
    puts "Pruned #{count} dead formula"

    count = 0
    # check symlinks are all set in each tap
    HOMEBREW_REPOSITORY.join("Library/Taps").children.each do |tap|
      files = []
      tap.find_formula{ |file| files << tap.basename.join(file) }
      count += link_tap_formula(files)
    end

    puts "Tapped #{count} formula"
  end

  private

  def tap_args return_nil = false
    case ARGV.first
    when %r{^(https?|git)://\S+/(\S+?)(\.git)?$}
      [ARGV.first, "direct_#{File.basename($2)}"]
    when %r{^\S+@\S+:(\S+?)(\.git)?$}
      [ARGV.first, "direct_#{File.basename($1)}"]
    when %r{^(\S+)/(homebrew-)?(\w+)$}
      user, repo = $1, $3

      # we special case homebrew so users don't have to shift in a terminal
      repouser = if user == "homebrew" then "Homebrew" else user end
      user = "homebrew" if user == "Homebrew"

      ["https://github.com/#{repouser}/homebrew-#{repo}", "#{user}-#{repo}"]
    else
      return nil if return_nil
      raise "Invalid usage"
    end
  end

end


class Pathname
  def tap_ref
    case self.to_s
    when %r{^#{HOMEBREW_LIBRARY}/Taps/([a-z\-_]+)-(\w+)/(.+)}
      "#$1/#$2/#{File.basename($3, '.rb')}"
    when %r{^#{HOMEBREW_LIBRARY}/Formula/(.+)}
      "mxcl/master/#{File.basename($1, '.rb')}"
    else
      nil
    end
  end
end
