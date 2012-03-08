module Homebrew extend self
  def update
    abort "Please `brew install git' first." unless system "/usr/bin/which -s git"

    updater = RefreshBrew.new
    if updater.update_from_masterbrew!
      updater.report
    else
      puts "Already up-to-date."
    end
  end
end

class RefreshBrew
  REPOSITORY_URL = "https://github.com/mxcl/homebrew.git"
  FORMULA_DIR = 'Library/Formula/'
  EXTERNAL_CMD_DIR = 'Library/Contributions/cmds/'

  attr_reader :added_formulae, :updated_formulae, :deleted_formulae, :installed_formulae
  attr_reader :added_external_commands, :deleted_external_commands
  attr_reader :initial_revision, :current_revision

  def initialize
    @added_formulae, @updated_formulae, @deleted_formulae, @installed_formulae = [], [], [], []
    @added_external_commands, @deleted_external_commands = [], [], []
    @initial_revision, @current_revision = nil
  end

  # Performs an update of the homebrew source. Returns +true+ if a newer
  # version was available, +false+ if already up-to-date.
  def update_from_masterbrew!
    # ensure GIT_CONFIG is unset as we need to operate on .git/config
    ENV.delete('GIT_CONFIG')

    HOMEBREW_REPOSITORY.cd do
      if git_repo?
        safe_system "git checkout -q master"
        @initial_revision = read_revision
        # originally we fetched by URL but then we decided that we should
        # use origin so that it's easier for forks to operate seamlessly
        unless `git remote`.split.include? 'origin'
          safe_system "git remote add origin #{REPOSITORY_URL}"
        end
      else
        begin
          safe_system "git init"
          safe_system "git config core.autocrlf false"
          safe_system "git remote add origin #{REPOSITORY_URL}"
          safe_system "git fetch origin"
          safe_system "git reset --hard origin/master"
        rescue Exception
          safe_system "/bin/rm -rf .git"
          raise
        end
      end

      # ensure we don't munge line endings on checkout
      safe_system "git config core.autocrlf false"
      # specify a refspec so that 'origin/master' gets updated
      refspec = "refs/heads/master:refs/remotes/origin/master"
      rebase = "--rebase" if ARGV.include? "--rebase"
      execute "git pull #{rebase} origin #{refspec}"
      @current_revision = read_revision
    end

    if initial_revision && initial_revision != current_revision
      # hash with status characters for keys:
      # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)
      @changes_map = Hash.new {|h,k| h[k] = [] }

      changes = HOMEBREW_REPOSITORY.cd do
        execute("git diff-tree -r --name-status -z #{initial_revision} #{current_revision}").split("\0")
      end

      while status = changes.shift
        file = changes.shift
        @changes_map[status] << file
      end

      if @changes_map.any?
        @added_formulae   = changed_items('A', FORMULA_DIR)
        @deleted_formulae = changed_items('D', FORMULA_DIR)
        @updated_formulae = changed_items('M', FORMULA_DIR)
        @added_external_commands = changed_items('A', EXTERNAL_CMD_DIR)
        @deleted_external_commands = changed_items('D', EXTERNAL_CMD_DIR)
        @added_internal_commands = changed_items('A', "Library/Homebrew/cmd")
        @deleted_internal_commands = changed_items('D', "Library/Homebrew/cmd")

        @installed_formulae = HOMEBREW_CELLAR.children.
          select{ |pn| pn.directory? }.
          map{ |pn| pn.basename.to_s }.sort if HOMEBREW_CELLAR.directory?

        return true
      end
    end
    # assume nothing was updated
    return false
  end

  def git_repo?
    Dir['.git/*'].length > 0
  end

  def pending_formulae_changes?
    !@updated_formulae.empty?
  end

  def pending_new_formulae?
    !@added_formulae.empty?
  end

  def deleted_formulae?
    !@deleted_formulae.empty?
  end

  def pending_external_commands_changes?
    !@updated_external_commands.empty?
  end

  def pending_new_external_commands?
    !@added_external_commands.empty?
  end

  def deleted_external_commands?
    !@deleted_external_commands.empty?
  end

  def report
    puts "Updated Homebrew from #{initial_revision[0,8]} to #{current_revision[0,8]}."
    if pending_new_formulae?
      ohai "New formulae"
      puts_columns added_formulae
    end
    if deleted_formulae?
      ohai "Removed formulae"
      puts_columns deleted_formulae, installed_formulae
    end
    if pending_formulae_changes?
      ohai "Updated formulae"
      puts_columns updated_formulae, installed_formulae
    end

    unless @added_internal_commands.empty?
      ohai "New commands"
      puts_columns @added_internal_commands
    end
    unless @deleted_internal_commands.empty?
      ohai "Removed commands"
      puts_columns @deleted_internal_commands
    end

    # external commands aren't generally documented but the distinction
    # is loose. They are less "supported" and more "playful".
    if pending_new_external_commands?
      ohai "New external commands"
      puts_columns added_external_commands
    end
    if deleted_external_commands?
      ohai "Removed external commands"
      puts_columns deleted_external_commands
    end
  end

  private

  def read_revision
    execute("git rev-parse HEAD").chomp
  end

  def filter_by_directory(files, dir)
    files.select { |f| f.index(dir) == 0 }
  end

  def basenames(files)
    files.map { |f| File.basename(f, '.rb') }
  end

  # extracts items by status from @changes_map
  def changed_items(status, dir)
    basenames(filter_by_directory(@changes_map[status], dir)).sort
  end

  def execute(cmd)
    out = `#{cmd}`
    if $? && !$?.success?
      $stderr.puts out
      raise "Failed while executing #{cmd}"
    end
    ohai(cmd, out) if ARGV.verbose?
    out
  end
end
